import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/movie.dart'; 
import 'package:los_pibbles_movies_app/presentation/widgets/animated_favorite_button.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/movie', extra: movie); 
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondary900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la película
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.imageUrl,
                width: 90,
                height: 130,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Container(width: 90, height: 130, color: AppColors.secondary700),
              ),
            ),
            const SizedBox(width: 16),
            // Detalles
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedFavoriteButton(movieId: movie.id, size: 24),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    movie.releaseDate != null ? movie.releaseDate!.year.toString() : '',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  
                  // Descripción de la película
                  Text(
                    movie.description,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating y Géneros
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      
                      // Chips de géneros
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: movie.genres.map((genre) => Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  // 🚀 Fondo del chip adaptado a un tono oscuro intermedio
                                  color: AppColors.secondary800,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    // 🚀 Color del texto del chip usando el morado claro del equipo
                                    color: AppColors.primary300, 
                                    fontSize: 11
                                  ),
                                ),
                              ),
                            )).toList(),
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
      ),
    ); 
  }
}