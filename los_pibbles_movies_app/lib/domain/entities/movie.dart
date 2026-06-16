import 'package:los_pibbles_movies_app/presentation/models/movie_model.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String imageUrl;
  final String rating;
  final String year;
  final String duration;
  final String subtitle;
  final bool isFavorite;
  final List<String> genres;
  final List<String> featuredTags;

  String get description => overview;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.imageUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.subtitle,
    this.isFavorite = false,
    this.genres = const [],
    this.featuredTags = const [],
  });

  factory Movie.fromDto(MovieDto dto, Map<int, String> genreMap) {
    final genreNames =
        dto.genreIds.map((id) => genreMap[id] ?? 'Desconocido').toList();

    return Movie(
      id: dto.id,
      title: dto.title,
      overview: dto.overview,
      imageUrl: dto.posterPath != null
          ? 'https://image.tmdb.org/t/p/w500${dto.posterPath}'
          : '',
      rating: dto.voteAverage.toStringAsFixed(1),
      year: dto.releaseDate != null && dto.releaseDate!.length >= 4
          ? dto.releaseDate!.substring(0, 4)
          : '—',
      duration: dto.runtime != null ? '${dto.runtime} min' : '—',
      subtitle: genreNames.isNotEmpty ? genreNames.first : 'Película',
      genres: genreNames,
      featuredTags: genreNames.take(3).toList(),
    );
  }
}
