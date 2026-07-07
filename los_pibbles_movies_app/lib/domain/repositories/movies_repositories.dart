import 'package:los_pibbles_movies_app/domain/datasources/tmdb_api_client.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/models/movie_model.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_actor.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_detail.dart';

class MoviesRepository {
  final TmdbApiClient _client = TmdbApiClient();
  Map<int, String>? _cachedGenres;

  Future<Map<int, String>> getGenres() async {
    if (_cachedGenres != null) return _cachedGenres!;

    final data = await _client.get('genre/movie/list');
    _cachedGenres = {
      for (final g in data['genres']) g['id'] as int: g['name'] as String,
    };
    return _cachedGenres!;
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final data = await _client.get('movie/now_playing',
        queryParams: {'page': '1'});
    final genreMap = await getGenres();
    return (data['results'] as List)
        .map((json) => MovieDto.fromJson(json))
        .map((dto) => Movie.fromDto(dto, genreMap))
        .toList();
  }

  Future<List<Movie>> getTrendingMovies() async {
    final data = await _client.get('trending/movie/week',
        queryParams: {'page': '1'});
    final genreMap = await getGenres();
    return (data['results'] as List)
        .map((json) => MovieDto.fromJson(json))
        .map((dto) => Movie.fromDto(dto, genreMap))
        .toList();
  }

  Future<List<Movie>> getPopularMovies() async {
    final data = await _client.get('movie/popular', queryParams: {'page': '1'});
    final genreMap = await getGenres();
    return (data['results'] as List)
        .map((json) => MovieDto.fromJson(json))
        .map((dto) => Movie.fromDto(dto, genreMap))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final data = await _client.get('search/movie',
        queryParams: {'query': query, 'page': '1'});
    final genreMap = await getGenres();
    final queryLower = query.toLowerCase();
    return (data['results'] as List)
        .map((json) => MovieDto.fromJson(json))
        .where((dto) => dto.title.toLowerCase().contains(queryLower))
        .map((dto) => Movie.fromDto(dto, genreMap))
        .toList();
  }
  Future<MovieDetail> getMovieDetail(int movieId) async {

  final detail =
      await _client.get('movie/$movieId');

  final credits =
      await _client.get('movie/$movieId/credits');

  final videos =
      await _client.get('movie/$movieId/videos');

  String director = '';

  final crew = credits['crew'] as List;

  for (final item in crew) {
    if (item['job'] == 'Director') {
      director = item['name'];
      break;
    }
  }

  final cast = (credits['cast'] as List)
      .take(10)
      .map((e) => MovieActor.fromJson(e))
      .toList();

  String trailerKey = '';

  final results = videos['results'] as List;

  for (final item in results) {

    if (item['site'] == 'YouTube' &&
        item['type'] == 'Trailer') {

      trailerKey = item['key'];

      break;
    }
  }

  return MovieDetail(

    director: director,

    cast: cast,

    trailerKey: trailerKey,

    runtime: detail['runtime'] ?? 0,


  );

}
}
