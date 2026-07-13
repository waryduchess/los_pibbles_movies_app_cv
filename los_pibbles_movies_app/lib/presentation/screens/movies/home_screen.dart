import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/category_selector.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/featured_movie_carousel.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/home_comments_section.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/movie_card_item.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home--screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreenBody();
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MoviesProvider>();

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent500,
        ),
      );
    }

    if (provider.errorType != null) {
      return CrErrorState(
        type: provider.errorType!,
        onRetry: provider.loadMovies,
      );
    }

    return _buildContent(
      context,
      provider.trending,
      provider.filteredPopular,
      provider.categories,
      provider.selectedCategory,
      provider.selectCategory,
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Movie> trending,
    List<Movie> popular,
    List<String> categories,
    String selectedCategory,
    ValueChanged<String> onSelectCategory,
  ) {
    return RefreshIndicator(
      color: AppColors.accent500,
      backgroundColor: AppColors.secondary900,
      onRefresh: () async {
        await context.read<MoviesProvider>().loadMovies();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            const SizedBox(height: 12),

            _buildSectionTitle(),

            const SizedBox(height: 18),

            FeaturedMovieCarousel(
              movies: trending.take(6).toList(),
            ),

            const SizedBox(height: 24),

            const Text(
              'Géneros',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onSelected: onSelectCategory,
            ),

            const SizedBox(height: 24),

            const Text(
              'Recomendadas',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            ...popular.take(10).map(
              (movie) => MovieCardItem(
                movie: movie,
              ),
            ),

            const HomeCommentsSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Image.asset(
          'lib/resources/images/logo.png',
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        const Text(
          'Pibble Movies',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return const Text(
      'Tendencias',
      style: TextStyle(
        color: AppColors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}