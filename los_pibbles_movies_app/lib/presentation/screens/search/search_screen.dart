import 'dart:async';

import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/movie_card_item.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/search_bar_widget.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class SearchScreen extends StatefulWidget {
  static const name = 'search--screen';

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MoviesRepository _repository = MoviesRepository();

  List<Movie> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() {
          _results = [];
          _isLoading = false;
          _hasSearched = false;
          _errorMessage = null;
        });
        return;
      }
      _performSearch(query.trim());
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final movies = await _repository.searchMovies(query);
      setState(() {
        _results = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _results = [];
        _isLoading = false;
        _errorMessage = 'Error al buscar: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  //IconButton(
                   // icon: const Icon(Icons.arrow_back, color: AppColors.white),
                   // onPressed: () => Navigator.of(context).pop(),
                  //),
                  const SizedBox(width: 8),
                  const Text(
                    'Búsqueda',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SearchBarWidget(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: AppColors.accent500),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Text(
          'Busca películas por título',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.55),
            fontSize: 16,
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron resultados',
          style: TextStyle(
            color: AppColors.white.withOpacity(0.55),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: MovieCardItem(movie: _results[index]),
      ),
    );
  }
}
