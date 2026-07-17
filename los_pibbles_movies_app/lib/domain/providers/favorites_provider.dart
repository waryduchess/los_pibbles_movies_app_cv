import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/infrastructure/db_connection.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<int> _favoriteMovieIds = {}; // Cambiado a int para coincidir con MySQL (id_pelicula)
  bool _isInitialized = false;
  int _idUsuario; // ID del usuario logueado en MySQL

  bool get isInitialized => _isInitialized;
  int get idUsuario => _idUsuario;
  
  // Lo exportamos como lista para proteger el Set original de modificaciones externas
  List<int> get favoriteMovieIds => _favoriteMovieIds.toList();

  // Pasamos el idUsuario en el constructor al iniciar sesión
  FavoritesProvider({required int idUsuario}) : _idUsuario = idUsuario {
    if (_idUsuario > 0) {
      _loadFavoritesFromMySQL();
    } else {
      _isInitialized = true;
    }
  }

  Future<void> loadFavoritesForUser(int newIdUsuario) async {
    _idUsuario = newIdUsuario;
    _favoriteMovieIds.clear();
    _isInitialized = false;
    notifyListeners();
    
    if (_idUsuario > 0) {
      await _loadFavoritesFromMySQL();
    } else {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // 🐬 LEER favoritos desde MySQL
  Future<void> _loadFavoritesFromMySQL() async {
    final conn = await DBConnection.getConnection();
    try {
      // Consulta basada en el script oficial
      final response = await conn.execute(
        'SELECT id_pelicula FROM favoritos WHERE id_usuario = :id_usuario',
        {'id_usuario': _idUsuario},
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
        // Borramos el registro
        await conn.execute(
          'DELETE FROM favoritos WHERE id_usuario = :id_usuario AND id_pelicula = :id_pelicula',
          {'id_usuario': _idUsuario, 'id_pelicula': movieId},
        );
      } else {
        // Insertamos el registro
        await conn.execute(
          'INSERT INTO favoritos (id_usuario, id_pelicula) VALUES (:id_usuario, :id_pelicula)',
          {'id_usuario': _idUsuario, 'id_pelicula': movieId},
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
        {'id_usuario': _idUsuario},
      );
    } catch (e) {
      debugPrint('Error borrando favoritos de MySQL: $e');
    } finally {
      await conn.close();
    }
  }

  // Llama a esto cuando el usuario CIERRE SESIÓN para limpiar la memoria caché
  void clearLocalState() {
    _idUsuario = 0; // Buena práctica reiniciar también el ID
    _favoriteMovieIds.clear();
    _isInitialized = false;
    notifyListeners();
  }
}