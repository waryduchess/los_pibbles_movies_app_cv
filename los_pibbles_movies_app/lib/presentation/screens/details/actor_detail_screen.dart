import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:los_pibbles_movies_app/domain/entities/actor_detail.dart';
import 'package:los_pibbles_movies_app/domain/providers/actor_provider.dart';
import 'package:los_pibbles_movies_app/domain/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class ActorDetailScreen extends StatefulWidget {
  final int actorId;

  const ActorDetailScreen({super.key, required this.actorId});

  @override
  State<ActorDetailScreen> createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  bool _isBioExpanded = false; // NUEVO: controla si se muestra toda la biografía

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ActorProvider>().loadActorDetail(widget.actorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActorProvider>();

    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        title: Text(
          provider.selectedActor?.name ?? 'Actor',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.secondary800,
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ActorProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final actor = provider.selectedActor;
    if (actor == null) {
      return Center(
        child: Text(
          provider.errorMessage ?? 'No se pudo cargar la información',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(actor),
          const SizedBox(height: 24),
          _buildBiography(actor),
          const SizedBox(height: 24),
          _buildMoviesSection(actor),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeader(ActorDetail actor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.secondary800,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.secondary700,
            backgroundImage:
                actor.profileUrl.isNotEmpty ? NetworkImage(actor.profileUrl) : null,
            child: actor.profileUrl.isEmpty
                ? const Icon(Icons.person, size: 50, color: AppColors.textSecondary)
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            actor.name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          if (actor.knownForDepartment.isNotEmpty)
            _infoChip(actor.knownForDepartment),
          const SizedBox(height: 8),
          if (actor.birthday != null || actor.placeOfBirth != null)
            Text(
              [
                if (actor.birthday != null) 'Nacimiento: ${actor.birthday}',
                if (actor.placeOfBirth != null) actor.placeOfBirth,
              ].join(' · '),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary500.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary300,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBiography(ActorDetail actor) {
    if (actor.biography.isEmpty) return const SizedBox.shrink();

    // NUEVO: límite de caracteres para el texto truncado
    const int limiteCaracteres = 150;
    final bool esLargo = actor.biography.length > limiteCaracteres;
    final String textoMostrado = _isBioExpanded || !esLargo
        ? actor.biography
        : '${actor.biography.substring(0, limiteCaracteres)}...';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biografía',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            textoMostrado,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          // NUEVO: botón "Ver más" / "Ver menos"
          if (esLargo)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isBioExpanded = !_isBioExpanded;
                  });
                },
                child: Text(
                  _isBioExpanded ? 'Ver menos' : 'Ver más',
                  style: const TextStyle(
                    color: AppColors.primary300,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMoviesSection(ActorDetail actor) {
    if (actor.movieCredits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Películas',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 260, // NUEVO: se aumentó de 230 a 260 para que el texto no se desborde (imagen sigue en 175)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actor.movieCredits.length,
            itemBuilder: (context, index) {
              final credit = actor.movieCredits[index];
              return _MovieCreditCard(
                credit: credit,
                onTap: () async {
                  final movie = await context
                      .read<MoviesProvider>()
                      .getMovieById(credit.id);
                  if (context.mounted) {
                    context.push('/movie-detail', extra: movie);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MovieCreditCard extends StatelessWidget {
  final dynamic credit;
  final VoidCallback onTap;

  const _MovieCreditCard({required this.credit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: credit.posterUrl.isNotEmpty
                  ? Image.network(
                      credit.posterUrl,
                      height: 175,
                      width: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 175,
                        color: AppColors.secondary800,
                        child: const Icon(
                          Icons.movie_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : Container(
                      height: 175,
                      color: AppColors.secondary800,
                      child: const Icon(
                        Icons.movie_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              credit.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              credit.character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}