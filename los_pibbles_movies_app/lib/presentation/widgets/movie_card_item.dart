import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/animated_favorite_button.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/tag_chip2.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';


class MovieCardItem extends StatelessWidget {
  final Movie movie;

  const MovieCardItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/movie-detail', extra: movie);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondary900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.secondary700,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                movie.imageUrl,
                width: 110,
                height: 165,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 165,
                    color: AppColors.secondary700,
                    child: const Icon(
                      Icons.movie,
                      color: AppColors.white,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedFavoriteButton(movieId: movie.id, size: 22),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${movie.year} • ${movie.subtitle}',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.75),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.72),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: movie.genres
                        .take(3)
                        .map((genre) => TagChip(label: genre))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}