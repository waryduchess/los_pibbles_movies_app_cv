import 'package:los_pibbles_movies_app/config/db/db_connection.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
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
        'SELECT id_usuario, nombres, password FROM usuarios WHERE correo = :correo',
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
}
