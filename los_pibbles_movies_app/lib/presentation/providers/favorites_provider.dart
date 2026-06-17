import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/db/db_connection.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favoriteMovieIds = {}; // Cambiado a int para coincidir con tu MySQL (id_pelicula)
  bool _isInitialized = false;
  final int idUsuario; // ID del usuario logueado en MySQL

  bool get isInitialized => _isInitialized;
  Set<int> get favoriteMovieIds => _favoriteMovieIds;

  // Pasamos el idUsuario en el constructor al iniciar sesión
  FavoritesProvider({required this.idUsuario}) {
    _loadFavoritesFromMySQL();
  }

  // 🐬 LEER favoritos desde MySQL
  Future<void> _loadFavoritesFromMySQL() async {
    final conn = await DBConnection.getConnection();
    try {
      // Consulta basada en el script oficial de tu equipo
      final response = await conn.execute(
        'SELECT id_pelicula FROM favoritos WHERE id_usuario = :id_usuario',
        {'id_usuario': idUsuario},
      );

      for (var row in response.rows) {
        final data = row.assoc();
        if (data['id_pelicula'] != null) {
          _favoriteMovieIds.add(int.parse(data['id_pelicula'].toString()));
        }
      }
    } catch (e) {
      debugPrint('Error cargando favoritos de MySQL: $e');
    } finally {
      await conn.close();
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  // 🐬 AGREGAR O QUITAR favorito en tiempo real usando MySQL
  Future<void> toggleFavorite(int movieId) async {
    final isFav = _favoriteMovieIds.contains(movieId);

    // 1. Enfoque Optimista: Actualizamos la interfaz INMEDIATAMENTE
    if (isFav) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }
    notifyListeners();

    // 2. Operación SQL en segundo plano
    final conn = await DBConnection.getConnection();
    try {
      if (isFav) {
        // Borramos el registro usando la tabla 'favoritos' de tu equipo
        await conn.execute(
          'DELETE FROM favoritos WHERE id_usuario = :id_usuario AND id_pelicula = :id_pelicula',
          {'id_usuario': idUsuario, 'id_pelicula': movieId},
        );
      } else {
        // Insertamos el registro
        await conn.execute(
          'INSERT INTO favoritos (id_usuario, id_pelicula) VALUES (:id_usuario, :id_pelicula)',
          {'id_usuario': idUsuario, 'id_pelicula': movieId},
        );
      }
    } catch (e) {
      debugPrint('Error actualizando favoritos en MySQL: $e');
      
      // Si falla la base de datos o la red, revertimos el cambio local
      if (isFav) {
        _favoriteMovieIds.add(movieId);
      } else {
        _favoriteMovieIds.remove(movieId);
      }
      notifyListeners();
    } finally {
      await conn.close();
    }
  }

  // 🐬 VACIAR toda la lista (Cuando el usuario decide limpiar sus favoritos)
  Future<void> clearFavorites() async {
    _favoriteMovieIds.clear();
    notifyListeners();
    
    final conn = await DBConnection.getConnection();
    try {
      await conn.execute(
        'DELETE FROM favoritos WHERE id_usuario = :id_usuario',
        {'id_usuario': idUsuario},
      );
    } catch (e) {
      debugPrint('Error borrando favoritos de MySQL: $e');
    } finally {
      await conn.close();
    }
  }

  // Llama a esto cuando el usuario CIERRE SESIÓN para limpiar la memoria caché
  void clearLocalState() {
    _favoriteMovieIds.clear();
    notifyListeners();
  }
}