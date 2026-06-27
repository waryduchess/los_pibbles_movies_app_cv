
// data/models/movie_dto.dart
class MovieDto {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String? releaseDate;
  final List<int> genreIds;
  // Opcional: si usas el endpoint de detalle, añade runtime, tagline, etc.
  final int? runtime;
  final String? tagline;

  MovieDto({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    this.releaseDate,
    this.genreIds = const [],
    this.runtime,
    this.tagline,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) {
    return MovieDto(
      id: json['id'],
      title: json['title'] ?? 'Sin título',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      runtime: json['runtime'],
      tagline: json['tagline'],
    );
  }
}
