import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:los_pibbles_movies_app/presentation/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class AnimatedFavoriteButton extends StatefulWidget {
  final int movieId;
  final double size;

  AnimatedFavoriteButton({
    Key? key,
    required this.movieId,
    this.size = 28,
  }) : super(key: key ?? ValueKey(movieId));

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _wasFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<FavoritesProvider>();
    final isFav = provider.isFavorite(widget.movieId);
    if (isFav != _wasFavorite) {
      _wasFavorite = isFav;
      if (isFav && !_controller.isAnimating) {
        _controller.value = 1.0;
      } else if (!isFav && !_controller.isAnimating) {
        _controller.value = 0.0;
      }
    }
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _wasFavorite = true;
    } else if (status == AnimationStatus.dismissed) {
      _wasFavorite = false;
    }
  }

  void _toggle() {
    final provider = context.read<FavoritesProvider>();
    final isFav = provider.isFavorite(widget.movieId);

    provider.toggleFavorite(widget.movieId);

    if (isFav) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FavoritesProvider>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggle,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Lottie.asset(
            'assets/animations/Add to favorites.json',
            controller: _controller,
            animate: false,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
