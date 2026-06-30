import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 📌 No olvides importar dotenv
import 'package:google_sign_in/google_sign_in.dart';
import 'package:los_pibbles_movies_app/config/db/db_connection.dart';

class AuthService {
  // 📌 Configuración de Google Sign-In (V7 CORRECTA)
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleInitialized = false;

  // 📌 AQUÍ ESTÁ LA SOLUCIÓN: Pasarle el Client ID al inicializar
  static Future<void> _initGoogle() async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize(
        // 👇 Esto soluciona la pantalla roja de Android que decía: 
        // "serverClientId must be provided on Android"
        serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
      );
      _isGoogleInitialized = true;
    }
  }

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 📌 INICIO DE SESIÓN TRADICIONAL
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

  // 📌 REGISTRO DE USUARIO TRADICIONAL
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

  // 📌 INICIO DE SESIÓN Y REGISTRO CON GOOGLE (V7)
  static Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // 1. Ejecutar la inicialización obligatoria
      await _initGoogle();

      // 2. Método 'authenticate()' correcto para la V7
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        return {'success': false, 'error': 'Inicio de sesión cancelado'};
      }

      final email = googleUser.email;
      final fullName = googleUser.displayName ?? 'Usuario';
      
      final nameParts = fullName.split(' ');
      final nombres = nameParts.isNotEmpty ? nameParts.first : 'Usuario';
      final apellidos = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final conn = await DBConnection.getConnection();
      try {
        final results = await conn.execute(
          'SELECT id_usuario, nombres, foto_perfil FROM usuarios WHERE correo = :correo',
          {'correo': email},
        );

        if (results.rows.isNotEmpty) {
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

  // 📌 CERRAR SESIÓN DE GOOGLE
  static Future<void> logoutGoogle() async {
    try {
      await _initGoogle(); 
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error cerrando sesión de Google: $e');
    }
  }
}