import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1.08 : 1.0,
        child: selected
            ? ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.primary500, AppColors.accent500],
                ).createShader(bounds),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.3,
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}