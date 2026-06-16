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
  int currentPage = 0;
  final pageController = PageController(viewportFraction: 0.95);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.movies.length,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: FeaturedMovieCard(movie: widget.movies[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.movies.asMap().entries.map((entry) {
            final active = entry.key == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 22 : 10,
              height: 8,
              decoration: BoxDecoration(
                color: active ? AppColors.primary500 : AppColors.secondary800,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
