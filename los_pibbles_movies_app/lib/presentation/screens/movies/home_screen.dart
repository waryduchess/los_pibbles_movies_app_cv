import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/presentation/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/category_selector.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/featured_movie_carousel.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/comment_section.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/movie_card_item.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/search_bar_widget.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
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
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.white),
          ),
        ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          const SearchBarWidget(),
          const SizedBox(height: 24),
          _buildSectionTitle(context),
          const SizedBox(height: 18),
          FeaturedMovieCarousel(movies: trending.take(6).toList()),
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
            (movie) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MovieCardItem(movie: movie),
            ),
          ),
          const SizedBox(height: 24),
          const CommentSection(),
        ],
      ),
    );
  }

  // Los métodos _buildHeader y _buildSectionTitle se mantienen igual que antes

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'lib/resources/images/logo.png',
              width: 32,
              height: 32,
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
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondary800,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.person_outline,
            color: AppColors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'Tendencias',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        
      ],
    );
  }
}

