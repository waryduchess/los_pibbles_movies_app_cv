import 'package:los_pibbles_movies_app/domain/datasources/tmdb_api_client.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/models/movie_model.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_actor.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_detail.dart';
import 'package:los_pibbles_movies_app/domain/entities/actor_detail.dart';
import 'package:los_pibbles_movies_app/domain/entities/actor_movie_credit.dart';

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

  Future<Movie> getMovieById(int movieId) async {
    final data = await _client.get('movie/$movieId');
    final genreMap = await getGenres();
    final dto = MovieDto.fromJson(data);
    return Movie.fromDto(dto, genreMap);
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

Future<ActorDetail> getActorDetail(int personId) async {
  final person = await _client.get('person/$personId');
  final credits = await _client.get('person/$personId/movie_credits');

  final movieCredits = (credits['cast'] as List)
      .map((e) => ActorMovieCredit.fromJson(e))
      .toList();

  final profilePath = person['profile_path'] as String?;

  return ActorDetail(
    id: person['id'] ?? personId,
    name: person['name'] ?? '',
    biography: person['biography'] ?? '',
    birthday: person['birthday'],
    placeOfBirth: person['place_of_birth'],
    profileUrl: profilePath != null
        ? 'https://image.tmdb.org/t/p/w500$profilePath'
        : '',
    knownForDepartment: person['known_for_department'] ?? 'Acting',
    movieCredits: movieCredits,
  );
}
}
