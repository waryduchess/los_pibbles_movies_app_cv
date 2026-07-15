import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';
import 'package:los_pibbles_movies_app/domain/providers/favorites_provider.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:provider/provider.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';
class FavoritesScreen extends StatefulWidget {
  static const name = 'favorites--screen';

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MoviesRepository _repository = MoviesRepository();
  List<Movie> _movies = [];
  bool _isLoading = true;
  String? _errorMessage;
  Set<int> _cachedFavoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final provider = context.read<FavoritesProvider>();
    final ids = provider.favoriteMovieIds.toList();

    _cachedFavoriteIds = provider.favoriteMovieIds.toSet();

    if (ids.isEmpty) {
      setState(() {
        _movies = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = ids.map((id) => _repository.getMovieById(id));
      final results = await Future.wait(futures);
      if (!mounted) return;
      setState(() {
        _movies = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar favoritos: $e';
      });
    }
  }

  void _syncWithProvider() {
    final provider = context.read<FavoritesProvider>();
    final newIds = provider.favoriteMovieIds;

    if (newIds.toSet().hashCode == _cachedFavoriteIds.hashCode) return;

    final removed = _cachedFavoriteIds.difference(newIds);
    final added = newIds.difference(_cachedFavoriteIds);

    _cachedFavoriteIds = newIds.toSet();

    if (removed.isNotEmpty) {
      final idsToRemove = removed.toSet();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        final currentIds = context.read<FavoritesProvider>().favoriteMovieIds;
        final toRemove = idsToRemove.where((id) => !currentIds.contains(id)).toSet();
        if (toRemove.isNotEmpty) {
          setState(() {
            _movies.removeWhere((m) => toRemove.contains(m.id));
          });
        }
      });
    }

    if (added.isNotEmpty) {
      _fetchNewMovies(added.toList());
    }
  }

  Future<void> _fetchNewMovies(List<int> movieIds) async {
    try {
      final futures = movieIds.map((id) => _repository.getMovieById(id));
      final results = await Future.wait(futures);
      if (!mounted) return;
      setState(() {
        _movies.addAll(results);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error al cargar nuevas películas: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoritesProvider>();

    _syncWithProvider();

    if (!provider.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.favoriteMovieIds.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 64),
              const SizedBox(height: 16),
              Text(
                'No tienes películas favoritas',
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Toca el corazón en cualquier película para agregarla',
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.45), fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Mis Favoritos',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadFavorites,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) => MovieCardItem(movie: _movies[index]),
    );
  }
}
