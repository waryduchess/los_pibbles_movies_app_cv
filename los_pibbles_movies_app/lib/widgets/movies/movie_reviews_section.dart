import 'package:flutter/material.dart';
// 🚀 Cambiamos el cliente de TMDB por tu datasource de MySQL
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart'; 
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import '../cards/movie_review_card.dart'; 

class MovieReviewsSection extends StatefulWidget {
  final int movieId; // El ID de la película seleccionada

  const MovieReviewsSection({
    super.key, 
    required this.movieId,
  });

  @override
  State<MovieReviewsSection> createState() => _MovieReviewsSectionState();
}

class _MovieReviewsSectionState extends State<MovieReviewsSection> {
  // 🚀 Instanciamos tu Datasource de MySQL
  final AuthBackendDatasource _authBackendDatasource = AuthBackendDatasource();
  
  late Future<List<Map<String, dynamic>>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    // 🚀 Llamamos a la consulta de la tabla 'comentarios' de tu equipo
    _reviewsFuture = _authBackendDatasource.getLocalMovieReviews(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        
        // 1. Estado de Carga (Con el color primario del equipo)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          );
        }

        // 2. Estado de Error
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Error al cargar los comentarios del servidor.',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          );
        }

        // 3. Estado Vacío (Sin comentarios en la BD de tu equipo)
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Aún no hay comentarios para esta película. ¡Sé el primero!',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          );
        }

        // 4. Estado de Éxito: Desplegamos los comentarios de MySQL
        final reviews = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(), 
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            
            // Construimos el nombre completo del usuario desde MySQL
            final String authorName = "${review['nombres'] ?? ''} ${review['apellidos'] ?? ''}".trim();
            
            return MovieReviewCard(
              user: authorName.isEmpty ? 'Usuario' : authorName,
              review: review['comentario'] ?? '',
              date: review['fecha']?.toString().substring(0, 10) ?? '', // Formato YYYY-MM-DD seguro
              rating: review['estrellas']?.toString() ?? '0', 
            );
          },
        );
      },
    );
  }
}