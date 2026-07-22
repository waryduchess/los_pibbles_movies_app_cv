import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/app_exception.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_detail.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';

class MoviesProvider extends ChangeNotifier {
  final MoviesRepository _repository = MoviesRepository();

  // Listas de películas
  List<Movie> trending = [];
  List<Movie> popular = [];

  // Categorías
  List<String> categories = [];
  String selectedCategory = 'Todos';

  // Estados
  bool isLoading = true;
  bool loadingMovieDetail = false;

  String? errorMessage;
  AppErrorType? errorType;

  // Detalle de película
  MovieDetail? selectedMovieDetail;

  // Películas filtradas
  List<Movie> get filteredPopular {
    if (selectedCategory == 'Todos') {
      return popular;
    }

    return popular
        .where((movie) => movie.genres.contains(selectedCategory))
        .toList();
  }

  // Cambiar categoría
  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  // Cargar películas
  Future<void> loadMovies() async {
    isLoading = true;
    errorMessage = null;
    errorType = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getTrendingMovies(),
        _repository.getPopularMovies(),
      ]);

      trending = results[0];
      popular = results[1];

      final allGenres = <String>{};

      for (final movie in [...trending, ...popular]) {
        allGenres.addAll(movie.genres);
      }

      categories = [
        'Todos',
        ...allGenres.toList()..sort(),
      ];
    } catch (e) {
      errorMessage = 'Error al cargar películas: $e';
      if (e is AppException) {
        errorType = e.type;
      } else {
        errorType = AppErrorType.unknown;
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Movie> getMovieById(int movieId) async {
    return _repository.getMovieById(movieId);
  }

  // Cargar detalle de película
  Future<void> loadMovieDetail(int movieId) async {
    loadingMovieDetail = true;
    notifyListeners();

    try {
      selectedMovieDetail =
          await _repository.getMovieDetail(movieId);
    } catch (e) {
      debugPrint('Error al cargar detalle: $e');
    }

    loadingMovieDetail = false;
    notifyListeners();
  }
}

