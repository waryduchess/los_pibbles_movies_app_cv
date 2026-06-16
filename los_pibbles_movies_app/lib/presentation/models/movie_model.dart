import 'package:flutter/material.dart';

class Movie {
  final String title;
  final String subtitle;
  final String year;
  final String duration;
  final String rating;
  final List<String> genres;
  final bool isFavorite;
  final String description;
  final String imageUrl;
  final List<String> featuredTags;

  const Movie({
    required this.title,
    required this.subtitle,
    required this.year,
    required this.duration,
    required this.rating,
    required this.genres,
    required this.isFavorite,
    required this.description,
    required this.imageUrl,
    this.featuredTags = const [],
  });
}
