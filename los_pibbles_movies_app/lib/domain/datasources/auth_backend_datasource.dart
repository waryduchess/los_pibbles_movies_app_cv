import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:los_pibbles_movies_app/config/db/db_connection.dart';
import 'package:los_pibbles_movies_app/domain/entities/app_exception.dart';

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
      throw AppException.databaseError();
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
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }
  // ... Dentro de tu clase AuthBackendDatasource ...

  /// Actualiza la foto de perfil del usuario en MySQL
  Future<void> updateProfilePhoto(int userId, String photoUrl) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        'UPDATE usuarios SET foto_perfil = :foto WHERE id_usuario = :id_usuario',
        {'foto': photoUrl, 'id_usuario': userId},
      );
    } catch (e) {
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }

  /// Obtiene los comentarios locales de una película desde MySQL
  Future<List<Map<String, dynamic>>> getLocalMovieReviews(int movieId) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT c.id_comentario, c.comentario, c.estrellas, c.fecha, u.nombres, u.apellidos, u.foto_perfil, u.id_usuario "
        "FROM comentarios c "
        "INNER JOIN usuarios u ON c.id_usuario = u.id_usuario "
        "WHERE c.id_pelicula = :movie_id "
        "ORDER BY c.fecha DESC",
        {"movie_id": movieId},
      );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }

  /// Inserta un nuevo comentario en MySQL
  Future<void> addComment(int userId, int movieId, String text, int stars) async {
    final conn = await DBConnection.getConnection();
    try {
      final maxIdResult = await conn.execute(
        "SELECT COALESCE(MAX(id_comentario), 0) + 1 AS next_id FROM comentarios"
      );
      final nextId = int.tryParse(maxIdResult.rows.first.assoc()['next_id'].toString()) ?? 1;

      await conn.execute(
        "INSERT INTO comentarios (id_comentario, id_usuario, id_pelicula, comentario, estrellas, fecha) "
        "VALUES (:id_comentario, :id_usuario, :id_pelicula, :comentario, :estrellas, NOW())",
        {
          "id_comentario": nextId,
          "id_usuario": userId,
          "id_pelicula": movieId,
          "comentario": text,
          "estrellas": stars,
        },
      );
    } catch (e) {
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }

  /// Obtiene el contador de likes de un comentario
  Future<int> getCommentLikeCount(int commentId) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT COUNT(*) AS total FROM likes_comentarios WHERE id_comentario = :id_comentario",
        {"id_comentario": commentId},
      );
      if (result.rows.isEmpty) return 0;
      return int.tryParse(result.rows.first.assoc()['total'].toString()) ?? 0;
    } catch (e) {
      return 0;
    } finally {
      await conn.close();
    }
  }

  /// Verifica si un usuario ya dio like a un comentario
  Future<bool> isCommentLikedByUser(int userId, int commentId) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT id_like FROM likes_comentarios WHERE id_usuario = :id_usuario AND id_comentario = :id_comentario",
        {"id_usuario": userId, "id_comentario": commentId},
      );
      return result.rows.isNotEmpty;
    } catch (e) {
      return false;
    } finally {
      await conn.close();
    }
  }

  /// Alterna el like de un comentario (agrega o quita)
  Future<bool> toggleLikeComment(int userId, int commentId) async {
    final conn = await DBConnection.getConnection();
    try {
      final existing = await conn.execute(
        "SELECT id_like FROM likes_comentarios WHERE id_usuario = :id_usuario AND id_comentario = :id_comentario",
        {"id_usuario": userId, "id_comentario": commentId},
      );

      if (existing.rows.isNotEmpty) {
        await conn.execute(
          "DELETE FROM likes_comentarios WHERE id_usuario = :id_usuario AND id_comentario = :id_comentario",
          {"id_usuario": userId, "id_comentario": commentId},
        );
        return false;
      } else {
        final maxIdResult = await conn.execute(
          "SELECT COALESCE(MAX(id_like), 0) + 1 AS next_id FROM likes_comentarios"
        );
        final nextId = int.tryParse(maxIdResult.rows.first.assoc()['next_id'].toString()) ?? 1;

        await conn.execute(
          "INSERT INTO likes_comentarios (id_like, id_usuario, id_comentario, fecha_like) VALUES (:id_like, :id_usuario, :id_comentario, NOW())",
          {"id_like": nextId, "id_usuario": userId, "id_comentario": commentId},
        );
        return true;
      }
    } catch (e) {
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }

  /// Obtiene los comentarios mas likeados de todas las peliculas (top global)
  Future<List<Map<String, dynamic>>> getTopComments({int limit = 10}) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT c.id_comentario, c.comentario, c.estrellas, c.fecha, c.id_pelicula, "
        "u.nombres, u.apellidos, u.foto_perfil, u.id_usuario, "
        "COUNT(lc.id_like) AS total_likes "
        "FROM comentarios c "
        "INNER JOIN usuarios u ON c.id_usuario = u.id_usuario "
        "LEFT JOIN likes_comentarios lc ON c.id_comentario = lc.id_comentario "
        "GROUP BY c.id_comentario "
        "ORDER BY c.fecha DESC "
        "LIMIT :limit",
        {"limit": limit},
      );

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      throw AppException.databaseError();
    } finally {
      await conn.close();
    }
  }

  /// Obtiene los likes que ha dado un usuario (para marcar iconos en UI)
  Future<Set<int>> getUserLikedCommentIds(int userId) async {
    final conn = await DBConnection.getConnection();
    try {
      final result = await conn.execute(
        "SELECT id_comentario FROM likes_comentarios WHERE id_usuario = :id_usuario",
        {"id_usuario": userId},
      );
      return result.rows
          .map((row) => int.tryParse(row.assoc()['id_comentario'].toString()) ?? 0)
          .toSet();
    } catch (e) {
      return {};
    } finally {
      await conn.close();
    }
  }
}