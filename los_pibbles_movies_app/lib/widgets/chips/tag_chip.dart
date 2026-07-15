import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool outlined;

  const TagChip({
    super.key,
    required this.label,
    this.selected = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? AppColors.primary500
        : AppColors.secondary800;
    final borderColor = outlined ? AppColors.primary500 : Colors.transparent;
    final textColor = selected
        ? AppColors.white
        : AppColors.white.withOpacity(0.85);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: outlined ? 1.2 : 0),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
