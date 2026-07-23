import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovieHeaderVideoWidget extends StatefulWidget {
  final String backdropUrl;
  final String? videoUrl;
  final String title;
  final String year;
  final String duration;
  final double rating;

  const MovieHeaderVideoWidget({
    super.key,
    required this.backdropUrl,
    this.videoUrl,
    required this.title,
    required this.year,
    required this.duration,
    required this.rating,
  });

  @override
  State<MovieHeaderVideoWidget> createState() => _MovieHeaderVideoWidgetState();
}

class _MovieHeaderVideoWidgetState extends State<MovieHeaderVideoWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isLoading = false;

  Future<void> _toggleVideoPlayback() async {
    // Si ya está inicializado y reproduciendo, pausamos/reanudamos
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        } else {
          _controller!.play();
        }
      });
      return;
    }

    // Si no hay URL de video disponible
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay video o trailer disponible para esta película'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Inicializamos el video por primera vez
    setState(() => _isLoading = true);

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
      await _controller!.initialize();

      setState(() {
        _isLoading = false;
        _isPlaying = true;
      });

      _controller!.play();
      
      // Escuchar cuando termine el video para resetear el botón
      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isPlaying = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el video: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      color: Colors.black,
      child: Stack(
        children: [
          // 1. CAPA POSTER / VIDEO
          Positioned.fill(
            child: _isPlaying && _controller != null && _controller!.value.isInitialized
                ? GestureDetector(
                    onTap: _toggleVideoPlayback,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                        if (!_controller!.value.isPlaying)
                          Container(
                            color: Colors.black54,
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
                : Image.network(
                    widget.backdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.movie, color: Colors.white24, size: 60),
                    ),
                  ),
          ),

          // 2. GRADIENTE OSCURO INFERIOR
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black12,
                    Colors.black87,
                    Colors.black,
                  ],
                  stops: [0.0, 0.4, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 3. BOTÓN MORADO PLAY (Solo visible cuando NO se está reproduciendo)
          if (!_isPlaying)
            Positioned.fill(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF7C5CFC))
                    : GestureDetector(
                        onTap: _toggleVideoPlayback,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C5CFC),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C5CFC).withAlpha(100),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 48,
                          ),
                        ),
                      ),
              ),
            ),

          // 4. TEXTO DE INFORMACIÓN (Título, año, duración y rating)
          Positioned(
            left: 20,
            bottom: 16,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      widget.year,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('•', style: TextStyle(color: Colors.white54)),
                    ),
                    Text(
                      widget.duration,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('•', style: TextStyle(color: Colors.white54)),
                    ),
                    _buildStarRating(widget.rating),
                    const SizedBox(width: 8),
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xFF9E86FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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

  Widget _buildStarRating(double rating) {
    double stars = rating / 2; // Escala de 10 a 5 estrellas
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < stars.floor()) {
          return const Icon(Icons.star_rounded, color: Colors.amber, size: 16);
        } else if (index < stars && (stars % 1) >= 0.5) {
          return const Icon(Icons.star_half_rounded, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_outline_rounded, color: Colors.amber, size: 16);
        }
      }),
    );
  }
}