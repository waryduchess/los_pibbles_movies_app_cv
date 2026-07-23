import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/repositories/movies_repositories.dart';
import 'package:los_pibbles_movies_app/domain/providers/favorites_provider.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

// 👇 Asegúrate de importar tus servicios
import 'package:los_pibbles_movies_app/domain/services/report_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart'; 


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
    final newIds = provider.favoriteMovieIds.toSet();

    if (newIds.hashCode == _cachedFavoriteIds.hashCode) return;

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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Título y Botón de Descarga
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Favoritos',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // 🔥 Aquí llamamos a tu nuevo widget, pasándole la lista _movies
                  // Solo lo mostramos si hay películas en la lista
                  if (_movies.isNotEmpty) 
                    GenerateReportButton(favoriteMovies: _movies),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBody(provider)), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FavoritesProvider provider) {
    if (provider.favoriteMovieIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 64),
            const SizedBox(height: 16),
            Text(
              'No tienes películas favoritas',
              style: TextStyle(color: AppColors.white.withOpacity(0.7), fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca el corazón en cualquier película para agregarla',
              style: TextStyle(color: AppColors.white.withOpacity(0.45), fontSize: 13),
            ),
          ],
        ),
      );
    }

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

// ============================================================================
// 📄 NUEVO WIDGET INDEPENDIENTE PARA EL BOTÓN DEL REPORTE
// Puedes dejarlo aquí o moverlo a "lib/widgets/favorites/generate_report_button.dart"
// ============================================================================
class GenerateReportButton extends StatefulWidget {
  final List<Movie> favoriteMovies;

  const GenerateReportButton({super.key, required this.favoriteMovies});

  @override
  State<GenerateReportButton> createState() => _GenerateReportButtonState();
}

class _GenerateReportButtonState extends State<GenerateReportButton> {
  bool _isGenerating = false;
  final ReportService _reportService = ReportService();

  Future<void> _handleGenerateReport() async {
    setState(() => _isGenerating = true);

    try {
      // Obtenemos el nombre del usuario (si no tienes SessionManager usa 'Usuario')
      final userName = SessionManager.userName ?? 'Usuario'; 
      
      await _reportService.generateFavoritesReport(widget.favoriteMovies, userName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Generando y abriendo PDF...'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: _isGenerating 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(color: AppColors.primary500, strokeWidth: 2)
              )
            : const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary500),
        onPressed: _isGenerating ? null : _handleGenerateReport,
        tooltip: 'Descargar Reporte PDF',
      ),
    );
  }
}