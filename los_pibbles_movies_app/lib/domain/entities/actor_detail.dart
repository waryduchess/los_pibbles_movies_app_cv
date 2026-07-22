import 'actor_movie_credit.dart';

class ActorDetail {
  final int id;
  final String name;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;
  final String profileUrl;
  final String knownForDepartment;
  final List<ActorMovieCredit> movieCredits;

  const ActorDetail({
    required this.id,
    required this.name,
    required this.biography,
    this.birthday,
    this.placeOfBirth,
    required this.profileUrl,
    this.knownForDepartment = 'Acting',
    this.movieCredits = const [],
  });
}