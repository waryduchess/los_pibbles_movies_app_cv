class ActorMovieCredit {
  final int id;
  final String title;
  final String character;
  final String posterUrl;
  final String? releaseDate;
  final double voteAverage;

  const ActorMovieCredit({
    required this.id,
    required this.title,
    required this.character,
    required this.posterUrl,
    this.releaseDate,
    this.voteAverage = 0,
  });

  factory ActorMovieCredit.fromJson(Map<String, dynamic> json) {
    return ActorMovieCredit(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      character: json['character'] ?? '',
      posterUrl: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w300${json['poster_path']}'
          : '',
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }
}