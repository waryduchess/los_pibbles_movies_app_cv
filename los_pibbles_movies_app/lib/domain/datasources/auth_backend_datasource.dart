import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:los_pibbles_movies_app/domain/infrastructure/db_connection.dart';

class AuthBackendDatasource {

  // Lee el .env para decidir si aplica la encriptación hash antes de interactuar con MySQL
  String _processPassword(String password) {
    final bool shouldHash = dotenv.env['HASH_PASSWORD'] == 'true';
    if (!shouldHash) return password;

    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString(); // Retorna Hash SHA-256 nativo
  }

  // 👇 1. ESTE ES EL NUEVO MÉTODO DE LOGIN QUE FALTABA 👇
  /// Inicia sesión y devuelve todos los datos del usuario, incluyendo favoritos
  Future<Map<String, dynamic>> login(String email, String password) async {
    final conn = await DBConnection.getConnection();
    try {
      // Pedimos todos los campos de la tabla usuarios (ajusta los nombres de columnas si son diferentes)
      final result = await conn.execute(
        "SELECT id_usuario, nombres, apellidos, foto_perfil, correo, fecha_registro, password "
        "FROM usuarios WHERE correo = :correo",
        {"correo": email},
      );

      if (result.rows.isEmpty) {
        throw Exception('Usuario no encontrado.');
      }

      final userRow = result.rows.first.assoc();
      final savedPassword = userRow['password']?.toString() ?? '';
      
      // Validamos la contraseña
      if (savedPassword != _processPassword(password)) {
        throw Exception('Contraseña incorrecta.');
      }

      final userId = int.parse(userRow['id_usuario'].toString());

      // Contamos los favoritos (si tienes la tabla 'favoritos')
      int favCount = 0;
      try {
        final favResult = await conn.execute(
          "SELECT COUNT(*) AS total FROM favoritos WHERE id_usuario = :id",
          {"id": userId},
        );
        if (favResult.rows.isNotEmpty) {
          favCount = int.tryParse(favResult.rows.first.assoc()['total'].toString()) ?? 0;
        }
      } catch (_) {
        // Si no tienes tabla de favoritos aún o se llama diferente, 
        // silenciamos el error para no arruinar el login
      }

      // Devolvemos el mapa que tu Auth_Service y LoginScreen están esperando
      return {
        "success": true,
        "userId": userId,
        "userName": "${userRow['nombres']} ${userRow['apellidos']}".trim(),
        "fotoPerfil": userRow['foto_perfil'],
        "userEmail": userRow['correo'],
        "memberSince": userRow['fecha_registro']?.toString(), 
        "favoritesCount": favCount,
      };

    } catch (e) {
      return {
        "success": false,
        "error": e.toString().replaceAll('Exception: ', ''),
      };
    } finally {
      await conn.close();
    }
  }
  // 👆 FIN DEL NUEVO MÉTODO DE LOGIN 👆


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

  /// Actualiza la foto de perfil del usuario en MySQL
  Future<void> updateProfilePhoto(int userId, String photoUrl) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        'UPDATE usuarios SET foto_perfil = :foto WHERE id_usuario = :id_usuario',
        {'foto': photoUrl, 'id_usuario': userId},
      );
    } catch (e) {
      throw Exception('No se pudo actualizar la foto de perfil: $e');
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
      throw Exception('Error al cargar comentarios desde MySQL: $e');
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
      throw Exception('Error al guardar comentario: $e');
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
      throw Exception('Error al alternar like: $e');
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
      throw Exception('Error al cargar top comentarios: $e');
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

  /// 4. Actualizar Nombre y Apellido
  Future<void> updateNameAndSurname(int userId, String nombres, String apellidos) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        "UPDATE usuarios SET nombres = :nombres, apellidos = :apellidos WHERE id_usuario = :id_usuario",
        {
          "nombres": nombres,
          "apellidos": apellidos,
          "id_usuario": userId,
        },
      );
    } catch (e) {
      throw Exception('Error al actualizar los datos en la base de datos.');
    } finally {
      await conn.close();
    }
  }

  /// 5. Actualizar Correo Electrónico
  Future<void> updateEmail(int userId, String nuevoCorreo) async {
    final conn = await DBConnection.getConnection();
    try {
      // Primero verificamos si el correo ya está siendo usado por OTRA persona
      final check = await conn.execute(
        "SELECT id_usuario FROM usuarios WHERE correo = :correo AND id_usuario != :id_usuario",
        {"correo": nuevoCorreo, "id_usuario": userId},
      );
      
      if (check.rows.isNotEmpty) {
        throw Exception('Este correo electrónico ya está en uso por otra cuenta.');
      }

      await conn.execute(
        "UPDATE usuarios SET correo = :correo WHERE id_usuario = :id_usuario",
        {
          "correo": nuevoCorreo,
          "id_usuario": userId,
        },
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      await conn.close();
    }
  }

  /// 3b. Establece una contraseña sin validar la actual (para cuentas Google)
  Future<void> setPassword(int userId, String newPassword) async {
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        "UPDATE usuarios SET password = :new_password WHERE id_usuario = :id_usuario",
        {
          "new_password": _processPassword(newPassword),
          "id_usuario": userId,
        },
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      await conn.close();
    }
  }

  /// 3. Cambia la contraseña validando primero la actual
  Future<void> changePasswordWithValidation(int userId, String currentPassword, String newPassword) async {
    final conn = await DBConnection.getConnection();
    try {
      // 1. Obtener la contraseña actual guardada en MySQL
      final result = await conn.execute(
        "SELECT password FROM usuarios WHERE id_usuario = :id_usuario",
        {"id_usuario": userId},
      );

      if (result.rows.isEmpty) {
        throw Exception('Usuario no encontrado.');
      }

      final savedPassword = result.rows.first.assoc()['password']?.toString() ?? '';
      
      // 2. Procesar la contraseña actual ingresada para compararla
      final hashedCurrentInput = _processPassword(currentPassword);

      if (savedPassword != hashedCurrentInput) {
        throw Exception('La contraseña actual es incorrecta.');
      }

      // 3. Si coincide, actualizar con la nueva contraseña
      await conn.execute(
        "UPDATE usuarios SET password = :new_password WHERE id_usuario = :id_usuario",
        {
          "new_password": _processPassword(newPassword),
          "id_usuario": userId,
        },
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    } finally {
      await conn.close();
    }
  }

}