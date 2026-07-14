class MovieActor {
  final String name;
  final String character;
  final String imageUrl;

  const MovieActor({
    required this.name,
    required this.character,
    required this.imageUrl,
  });

  factory MovieActor.fromJson(Map<String, dynamic> json) {
    return MovieActor(
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      imageUrl: json['profile_path'] != null
          ? 'https://image.tmdb.org/t/p/w300${json['profile_path']}'
          : '',
    );
  }
}