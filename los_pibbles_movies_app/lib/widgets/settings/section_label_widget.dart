import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class SectionLabelWidget extends StatelessWidget {
  final String text;

  const SectionLabelWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
