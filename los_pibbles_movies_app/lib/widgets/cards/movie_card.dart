import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../../domain/entities/movie.dart';
// 🚀 Importamos los colores de tu equipo
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  double _heartScale = 1.0;

  // 🌟 LÓGICA DE ANIMACIÓN DEL CORAZÓN
  void _handleFavoriteTap() async {
    HapticFeedback.lightImpact(); 
    
    setState(() => _heartScale = 0.7);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _heartScale = 1.2);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _heartScale = 1.0);
    
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondary900, // 🚀 Fondo oscuro de la tarjeta unificado
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Imagen del póster (Izquierda)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.movie.imageUrl,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 90,
                height: 130,
                color: AppColors.secondary800,
                child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 2. Información de la película (Derecha)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y Corazón
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // 🌟 BOTÓN DE FAVORITO CON ANIMACIÓN Y LÓGICA
                    GestureDetector(
                      onTap: _handleFavoriteTap,
                      behavior: HitTestBehavior.opaque, 
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: AnimatedScale(
                          scale: _heartScale,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          child: Icon(
                            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            // 🚀 Usamos el color de error/favorito del equipo o gris
                            color: widget.isFavorite ? AppColors.error : AppColors.textSecondary, 
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // 🚀 Año (Eliminamos el llamado a 'director' que rompía la app)
                Text(
                  '${widget.movie.year}', // Asumiendo que tu modelo Movie ahora tiene el campo 'year'
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                
                // Sinopsis corta
                Text(
                  widget.movie.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.3),
                ),
                const SizedBox(height: 8),
                
                // Estrellas y Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      widget.movie.rating.toString(),
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Etiquetas de Género (Pills)
                Wrap(
                  spacing: 8,
                  runSpacing: 8, // Por si saltan a la siguiente línea
                  children: widget.movie.genres.map((genre) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary800, // Fondo del pill
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: AppColors.primary400, // Texto morado claro
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )).toList(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}