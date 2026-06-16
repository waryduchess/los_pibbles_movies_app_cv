import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/presentation/models/movie_model.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/category_selector.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/featured_movie_carousel.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/movie_card_item.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/search_bar_widget.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home--screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: HomeScreenBody()));
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
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
          FeaturedMovieCarousel(movies: featuredMovies),
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
          CategorySelector(categories: categories, selectedCategory: 'Todos'),
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
          ...movieList.map(
            (movie) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: MovieCardItem(movie: movie),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Pibble Movies',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Encuentra tu próxima película favorita',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
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
          'Rating',
          style: TextStyle(
            color: AppColors.primary500,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'DESTACADAS',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

const categories = ['Todos', 'Drama', 'Misterio', 'Musical'];

const featuredMovies = [
  Movie(
    title: 'La Sombra del Norte',
    subtitle: 'Thriller / Crimen',
    year: '2022',
    duration: '2h 04min',
    rating: '7.8',
    genres: ['Thriller', 'Crimen'],
    isFavorite: true,
    description:
        'Una historia oscura de secretos perdidos en las calles del norte.',
    imageUrl:
        'https://images.unsplash.com/photo-1517602302552-471fe67acf66?auto=format&fit=crop&w=900&q=80',
    featuredTags: ['Thriller', 'Crimen'],
  ),
  Movie(
    title: 'Entre Sombras',
    subtitle: 'Suspenso / Misterio',
    year: '2024',
    duration: '1h 58min',
    rating: '8.3',
    genres: ['Suspenso', 'Misterio'],
    isFavorite: false,
    description:
        'Un detective debe descifrar una red de pistas antes de que sea tarde.',
    imageUrl:
        'https://images.unsplash.com/photo-1524985069026-dd778a71c7b4?auto=format&fit=crop&w=900&q=80',
    featuredTags: ['Misterio', 'Drama'],
  ),
];

const movieList = [
  Movie(
    title: 'El Último Acto',
    subtitle: 'Carmen Rojas',
    year: '2023',
    duration: '1h 45min',
    rating: '9.1',
    genres: ['Drama'],
    isFavorite: true,
    description:
        'Una actriz de teatro enfrenta su última función mientras lidia con un oscuro pasado.',
    imageUrl:
        'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=700&q=80',
  ),
  Movie(
    title: 'Ecos del Pasado',
    subtitle: 'Ramón Delgado',
    year: '2023',
    duration: '2h 01min',
    rating: '8.4',
    genres: ['Drama', 'Misterio'],
    isFavorite: false,
    description:
        'Un periodista investiga un misterio que conecta su pasado con una vieja desaparición.',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=700&q=80',
  ),
  Movie(
    title: 'Espejo Roto',
    subtitle: 'Lucía Díaz',
    year: '2024',
    duration: '1h 50min',
    rating: '8.7',
    genres: ['Suspenso', 'Thriller'],
    isFavorite: false,
    description:
        'Una joven descubre un reflejo que no pertenece a su realidad y debe escapar.',
    imageUrl:
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=700&q=80',
  ),
];
