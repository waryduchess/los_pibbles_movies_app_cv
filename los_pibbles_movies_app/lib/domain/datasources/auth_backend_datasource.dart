import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:los_pibbles_movies_app/config/db/db_connection.dart';

class AuthBackendDatasource {

  // Lee el .env para decidir si aplica la encriptación hash antes de interactuar con MySQL
  String _processPassword(String password) {
    final bool shouldHash = dotenv.env['HASH_PASSWORD'] == 'true';
    if (!shouldHash) return password;

    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString(); // Retorna Hash SHA-256 nativo
  }

  /// 1. Verifica si el correo existe en la tabla de MySQL de tu equipo
  Future<bool> checkEmailExists(String email) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT id_usuario FROM usuarios WHERE correo = :correo",
        {"correo": email},
      );
      return result.rows.isNotEmpty;
    } catch (e) {
      throw Exception('Error al conectar con la base de datos de usuarios.');
    } finally {
      await conn.close();
    }
  }

  /// 2. Cambia la contraseña directamente en MySQL aplicando el hash dinámico
  Future<void> forceUpdatePassword(String email, String newPassword) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        "UPDATE usuarios SET password = :password WHERE correo = :correo",
        {
          "password": _processPassword(newPassword),
          "correo": email,
        },
      );
    } catch (e) {
      throw Exception('No se pudo actualizar la contraseña en el servidor MySQL.');
    } finally {
      await conn.close();
    }
  }
  // ... Dentro de tu clase AuthBackendDatasource ...

  /// Obtiene los comentarios locales de una película desde MySQL
  Future<List<Map<String, dynamic>>> getLocalMovieReviews(int movieId) async {
    final conn = await DBConnection.getConnection();
    try {
      // Hacemos un JOIN con la tabla usuarios para saber quién escribió el comentario
      final result = await conn.execute(
        "SELECT c.comentario, c.estrellas, c.fecha, u.nombres, u.apellidos, u.foto_perfil "
        "FROM comentarios c "
        "INNER JOIN usuarios u ON c.id_usuario = u.id_usuario "
        "WHERE c.id_pelicula = :movie_id "
        "ORDER BY c.fecha DESC",
        {"movie_id": movieId},
      );

      // Convertimos las filas a una lista de mapas estándar
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      throw Exception('Error al cargar comentarios desde MySQL: $e');
    } finally {
      await conn.close();
    }
  }



}