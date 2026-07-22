import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_actor.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/cards/movie_actor_card.dart';

class FullCastScreen extends StatelessWidget {
  final List<MovieActor> cast;

  const FullCastScreen({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        title: const Text('Reparto completo'),
        backgroundColor: AppColors.secondary800,
      ),
      body: GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 14,
        crossAxisSpacing: 8,
        childAspectRatio: 0.55,
        children: cast.map((actor) => MovieActorCard(
          name: actor.name,
          role: actor.character,
          imageUrl: actor.imageUrl,
        )).toList(),
      ),
    );
  }
}
