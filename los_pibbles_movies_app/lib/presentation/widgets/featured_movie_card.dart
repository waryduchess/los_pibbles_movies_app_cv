import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
//import 'package:los_pibbles_movies_app/presentation/widgets/tag_chip2.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:go_router/go_router.dart';

class FeaturedMovieCard extends StatelessWidget {
  final Movie movie;
  const FeaturedMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand, 
        children: [
          
          Positioned.fill(
            child: Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: AppColors.secondary900);
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.10),
                    AppColors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  //children: movie.featuredTags
                      //.map((tag) => TagChip(label: tag, selected: true))
                      //.toList(),
                ),
                const Spacer(),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      movie.year,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.75),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                            context.push('/movie-detail', extra: movie);
                          },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow, color: AppColors.white, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'Ver resumen',
                              style: TextStyle(color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}