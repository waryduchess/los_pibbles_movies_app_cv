import 'movie_actor.dart';

class MovieDetail {
  final String director;
  final List<MovieActor> cast;
  final String trailerKey;
  final int runtime;

  const MovieDetail({
    required this.director,
    required this.cast,
    required this.trailerKey,
    required this.runtime,
  });
}