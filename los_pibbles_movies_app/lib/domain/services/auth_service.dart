import 'package:los_pibbles_movies_app/config/db/db_connection.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart'; // 📌 Importación requerida

class AuthService {
  // 📌 Configuración de Google Sign-In (ACTUALIZADO V7)
  // 1. Usamos el patrón de instancia única
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleInitialized = false;

  // 2. Método interno para asegurar la inicialización obligatoria
  static Future<void> _initGoogle() async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize();
      _isGoogleInitialized = true;
    }
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<Map<String, dynamic>> login(
    String correo,
    String password,
  ) async {
    final conn = await DBConnection.getConnection();
    try {
      final results = await conn.execute(
        'SELECT id_usuario, nombres, apellidos, foto_perfil, password FROM usuarios WHERE correo = :correo',
        {'correo': correo},
      );

      if (results.rows.isEmpty) {
        return {'success': false, 'error': 'Correo o contraseña incorrectos'};
      }

      final user = results.rows.first.assoc();
      final storedPassword = user['password']!;
      final hashedInput = _hashPassword(password);

      if (storedPassword != hashedInput) {
        return {'success': false, 'error': 'Correo o contraseña incorrectos'};
      }

      return {
        'success': true,
        'userId': user['id_usuario']!,
        'userName': user['nombres']!,
        'fotoPerfil': user['foto_perfil'],
      };
    } finally {
      await conn.close();
    }
  }

  static Future<Map<String, dynamic>> register(
    String nombres,
    String apellidos,
    String correo,
    String password,
  ) async {
    final conn = await DBConnection.getConnection();
    try {
      final existing = await conn.execute(
        'SELECT id_usuario FROM usuarios WHERE correo = :correo',
        {'correo': correo},
      );

      if (existing.rows.isNotEmpty) {
        return {'success': false, 'error': 'Este correo ya está registrado'};
      }

      final hashedPassword = _hashPassword(password);

      await conn.execute(
        'INSERT INTO usuarios (nombres, apellidos, correo, password, fecha_registro) VALUES (:nombres, :apellidos, :correo, :password, NOW())',
        {
          'nombres': nombres,
          'apellidos': apellidos,
          'correo': correo,
          'password': hashedPassword,
        },
      );

      return {'success': true, 'message': 'Usuario registrado exitosamente'};
    } finally {
      await conn.close();
    }
  }

  // 📌 Método para inicio de sesión y registro con Google (ACTUALIZADO V7)
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // 1. Ejecutar la inicialización obligatoria de la V7
      await _initGoogle();

      // 2. Mostrar la ventana de Google usando el nuevo método 'authenticate()'
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        return {'success': false, 'error': 'Inicio de sesión cancelado'};
      }

      final email = googleUser.email;
      final fullName = googleUser.displayName ?? 'Usuario';
      
      // Separamos el nombre completo de Google en nombres y apellidos para tu BD
      final nameParts = fullName.split(' ');
      final nombres = nameParts.isNotEmpty ? nameParts.first : 'Usuario';
      final apellidos = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final conn = await DBConnection.getConnection();
      try {
        // 3. Verificar si el usuario ya existe en tu base de datos
        final results = await conn.execute(
          'SELECT id_usuario, nombres, foto_perfil FROM usuarios WHERE correo = :correo',
          {'correo': email},
        );

        if (results.rows.isNotEmpty) {
          // Si ya existe, simplemente lo logueamos
          final user = results.rows.first.assoc();
          return {
            'success': true,
            'data': {
              'userId': user['id_usuario']!,
              'userName': user['nombres']!,
              'fotoPerfil': user['foto_perfil'],
            }
          };
        } else {
          // 4. Si no existe, lo registramos usando los datos de Google
          // Generamos un hash con su ID de Google como contraseña temporal segura
          final placeholderPassword = _hashPassword('GOOGLE_${googleUser.id}');

          await conn.execute(
            'INSERT INTO usuarios (nombres, apellidos, correo, password, fecha_registro) VALUES (:nombres, :apellidos, :correo, :password, NOW())',
            {
              'nombres': nombres,
              'apellidos': apellidos,
              'correo': email,
              'password': placeholderPassword,
            },
          );

          // Obtenemos el ID que se le acaba de asignar
          final newUserResults = await conn.execute(
            'SELECT id_usuario, foto_perfil FROM usuarios WHERE correo = :correo',
            {'correo': email},
          );
          
          final newUser = newUserResults.rows.first.assoc();

          return {
            'success': true,
            'data': {
              'userId': newUser['id_usuario']!,
              'userName': nombres,
              'fotoPerfil': newUser['foto_perfil'],
            }
          };
        }
      } finally {
        await conn.close();
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión con Google o BD: $e'};
    }
  }

  // 📌 Método opcional por si necesitas cerrar la sesión de Google
  static Future<void> logoutGoogle() async {
    try {
      await _initGoogle(); // Inicializamos por si llaman a cerrar sesión antes de abrirla
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error cerrando sesión de Google: $e');
    }
  }
}