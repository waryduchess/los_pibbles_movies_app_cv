import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MoviesProvider>().loadMovieDetail(widget.movie.id);
    });
  }

  Future<void> _openTrailer() async {
    final provider = context.read<MoviesProvider>();
    final trailerKey = provider.selectedMovieDetail?.trailerKey;

    if (trailerKey == null || trailerKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontró trailer externo disponible')),
      );
      return;
    }

    final url = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final provider = context.watch<MoviesProvider>();

    return Scaffold(
      backgroundColor: AppColors.secondary1000,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accent500,
          backgroundColor: AppColors.secondary900,
          onRefresh: () async {
            await context.read<MoviesProvider>().loadMovieDetail(movie.id);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎬 Header principal con soporte para reproductor de YouTube
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
                          label: const Text('Ver trailer en YouTube'),
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
                        child: AnimatedFavoriteButton(
                          movieId: movie.id,
                          size: 28,
                          movieTitle: movie.title,
                        ),
                      ),
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
                        value: provider.selectedMovieDetail?.director ?? 'Cargando...',
                      ),
                      MovieTechInfo(
                        icon: Icons.access_time,
                        title: 'Duración',
                        value: provider.selectedMovieDetail != null
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

                Row(
                  children: [
                    const Text(
                      'Reparto',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        final cast = context
                            .read<MoviesProvider>()
                            .selectedMovieDetail
                            ?.cast;
                        if (cast != null) {
                          context.push('/full-cast', extra: cast);
                        }
                      },
                      child: const Text(
                        'Ver más',
                        style: TextStyle(
                          color: AppColors.primary500,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                provider.loadingMovieDetail
                    ? const SizedBox(
                        height: 110,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Row(
                        children: [
                          for (int i = 0;
                              i < min(4, provider.selectedMovieDetail?.cast.length ?? 0);
                              i++)
                            Expanded(
                              child: MovieActorCard(
                                name: provider.selectedMovieDetail!.cast[i].name,
                                role: provider.selectedMovieDetail!.cast[i].character,
                                imageUrl: provider.selectedMovieDetail!.cast[i].imageUrl,
                              ),
                            ),
                        ],
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

// ============================================================================
// 🎬 SUBWIDGET HEADER CON YOUTUBE PLAYER INLINE
// ============================================================================

class _HeaderMovie extends StatefulWidget {
  final Movie movie;

  const _HeaderMovie({required this.movie});

  @override
  State<_HeaderMovie> createState() => _HeaderMovieState();
}

class _HeaderMovieState extends State<_HeaderMovie> {
  YoutubePlayerController? _youtubeController;
  bool _isPlaying = false;

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _playTrailer(String? trailerKey) {
    if (trailerKey == null || trailerKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay trailer de YouTube disponible para esta película'),
          backgroundColor: AppColors.secondary800,
        ),
      );
      return;
    }

    if (_youtubeController == null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: trailerKey,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      );
    } else {
      _youtubeController!.load(trailerKey);
    }

    setState(() {
      _isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MoviesProvider>();
    final movie = widget.movie;
    final movieDetail = provider.selectedMovieDetail;

    final displayDuration = movieDetail != null
        ? '${movieDetail.runtime} min'
        : movie.duration.isNotEmpty
            ? movie.duration
            : '...';

    // Se obtiene el trailerKey generado desde la API
    final trailerKey = movieDetail?.trailerKey;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Imagen de portada O Reproductor de YouTube
            _isPlaying && _youtubeController != null
                ? YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: AppColors.primary500,
                    progressColors: const ProgressBarColors(
                      playedColor: AppColors.primary500,
                      handleColor: AppColors.accent500,
                    ),
                  )
                : Image.network(
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

            // 2. Capas superiores (Gradiante, botones e info) solo visibles antes de dar Play
            if (!_isPlaying) ...[
              // Overlay Gradiente Oscuro
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

              // Botón Morado de Play Central
              Center(
                child: GestureDetector(
                  onTap: () => _playTrailer(trailerKey),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 42,
                    ),
                  ),
                ),
              ),

              // Botón de Regresar
              Positioned(
                top: 14,
                left: 14,
                child: _CircleActionButton(
                  icon: Icons.arrow_back,
                  color: AppColors.white,
                  onTap: () => context.pop(),
                ),
              ),

              // Detalles de la película
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
                          displayDuration,
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