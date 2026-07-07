import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/widgets/cards/movie_review_card.dart';

class MovieReviewsSection extends StatelessWidget {
  final int movieId;

  const MovieReviewsSection({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'user': '@CineFilm_MX',
        'review':
            'Una obra maestra del suspenso latinoamericano. Los giros son impredecibles.',
        'date': '13 nov 2023',
        'rating': '5',
      },
      {
        'user': '@Paulina_R',
        'review':
            'Actuaciones sobresalientes. La fotografía es increíble y mantiene la tensión.',
        'date': '29 oct 2023',
        'rating': '5',
      },
      {
        'user': '@MovieFan',
        'review':
            'Muy buena historia, buen ritmo y personajes interesantes de principio a fin.',
        'date': '05 sep 2023',
        'rating': '5',
      },
    ];

    return Column(
      children: reviews.map((review) {
        return MovieReviewCard(
          user: review['user']!,
          review: review['review']!,
          date: review['date']!,
          rating: review['rating']!,
        );
      }).toList(),
    );
  }
}