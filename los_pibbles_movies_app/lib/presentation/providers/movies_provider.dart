import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';

class MoviesProvider extends ChangeNotifier {
  final MoviesRepository _repository = MoviesRepository();

  List<Movie> trending = [];
  List<Movie> popular = [];
  List<String> categories = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> loadMovies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getTrendingMovies(),
        _repository.getPopularMovies(),
      ]);
      trending = results[0];
      popular = results[1];

      final allGenres = <String>{};
      for (final m in [...trending, ...popular]) {
        allGenres.addAll(m.genres);
      }
      categories = ['Todos', ...allGenres.toList()..sort()];
    } catch (e) {
      errorMessage = 'Error al cargar películas: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
