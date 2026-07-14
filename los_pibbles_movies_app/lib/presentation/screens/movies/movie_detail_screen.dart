import 'package:los_pibbles_movies_app/presentation/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/animated_favorite_button.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MoviesProvider>().loadMovieDetail(
        widget.movie.id,
      );
    });
  }

Future<void> _openTrailer() async {
  final provider =
      context.read<MoviesProvider>();

  final trailerKey =
      provider.selectedMovieDetail?.trailerKey;

  if (trailerKey == null ||
      trailerKey.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No se encontró trailer disponible',
        ),
      ),
    );

    return;
  }

  final url = Uri.parse(
    'https://www.youtube.com/watch?v=$trailerKey',
  );

  await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );
}

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    final provider =
    context.watch<MoviesProvider>();

    return Scaffold(
      backgroundColor: AppColors.secondary1000,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent500,
          backgroundColor: AppColors.secondary900,
          onRefresh: () async {
            await context.read<MoviesProvider>().loadMovieDetail(
              movie.id,
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderMovie(movie: movie),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: _openTrailer,
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Ver trailer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary600,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.secondary900.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: AnimatedFavoriteButton(movieId: movie.id, size: 28, movieTitle: movie.title),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CircleActionButton(
                      icon: Icons.share_outlined,
                      color: AppColors.white,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Resumen',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  movie.overview.isNotEmpty
                      ? movie.overview
                      : 'No hay sinopsis disponible para esta película.',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary900,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.secondary700),
                  ),
                  child: Column(
                    children: [
                      MovieTechInfo(
                        icon: Icons.movie_creation_outlined,
                        title: 'Director',
                        value:
                          provider.selectedMovieDetail?.director ??
                          'Cargando...',
                      ),
                      MovieTechInfo(
                        icon: Icons.access_time,
                        title: 'Duración',
                        value:
                            provider.selectedMovieDetail != null
                                ? '${provider.selectedMovieDetail!.runtime} min'
                                : movie.duration,
                      ),
                      MovieTechInfo(
                        icon: Icons.category_outlined,
                        title: 'Género',
                        value: movie.genres.isNotEmpty
                            ? movie.genres.take(2).join(', ')
                            : movie.subtitle,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Reparto',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 110,
                  child: provider.loadingMovieDetail
                      ? const Center(
                          child:
                              CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount:
                              provider
                                  .selectedMovieDetail
                                  ?.cast
                                  .length ??
                              0,
                          itemBuilder:
                              (context, index) {
                            final actor =
                                provider
                                    .selectedMovieDetail!
                                    .cast[index];

                            return MovieActorCard(
                              name: actor.name,
                              role: actor.character,
                              imageUrl:
                                  actor.imageUrl,
                            );
                          },
                        ),
                ),

                const SizedBox(height: 22),

                if (SessionManager.userId != null)
                  MovieCommentsSection(
                    movieId: movie.id,
                    userId: SessionManager.userId!,
                  )
                else
                  MovieReviewsSection(movieId: movie.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderMovie extends StatelessWidget {
  final Movie movie;

  const _HeaderMovie({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.secondary800,
                  child: const Icon(
                    Icons.movie,
                    color: AppColors.white,
                    size: 70,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withOpacity(0.20),
                    AppColors.black.withOpacity(0.85),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: _CircleActionButton(
                icon: Icons.arrow_back,
                color: AppColors.white,
                onTap: () => context.pop(),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        movie.year,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '•',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        movie.duration,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '•',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.star,
                        color: AppColors.warning,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.secondary900.withOpacity(0.9),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}