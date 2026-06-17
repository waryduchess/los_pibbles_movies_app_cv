import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/featured_movie_card.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class FeaturedMovieCarousel extends StatefulWidget {
  final List<Movie> movies;
  const FeaturedMovieCarousel({super.key, required this.movies});

  @override
  State<FeaturedMovieCarousel> createState() => _FeaturedMovieCarouselState();
}

class _FeaturedMovieCarouselState extends State<FeaturedMovieCarousel> {
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  double _page = 0;
  int _currentIndex = 0;

  static const _autoPlayInterval = Duration(seconds: 5);
  static const _transitionDuration = Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(viewportFraction: 1.0);
    _pageController.addListener(_onPageScroll);
    _startAutoPlay();
  }

  void _onPageScroll() {
    setState(() => _page = _pageController.page ?? 0);
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.movies.length <= 1) return;
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted) return;
      final next = (_currentIndex + 1) % widget.movies.length;
      _pageController.animateToPage(
        next,
        duration: _transitionDuration,
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _pauseAutoPlayTemporarily() {
    _autoPlayTimer?.cancel();
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 280
          , 
          child: Listener(
            onPointerDown: (_) => _pauseAutoPlayTemporarily(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.movies.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final diff = _page - index;
                final scale = (1 - (diff.abs() * 0.05)).clamp(0.95, 1.0);
                final opacity = (1 - (diff.abs() * 0.4)).clamp(0.5, 1.0);
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                   
                    child: FeaturedMovieCard(movie: widget.movies[index]),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 18),
        _buildIndicator(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.movies.length, (index) {
        final distance = (_page - index).abs().clamp(0.0, 1.0);
        final width = lerpDouble(22, 8, distance) ?? 8;
        final color = Color.lerp(
          AppColors.primary500,
          AppColors.secondary800,
          distance,
        );
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: width,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}