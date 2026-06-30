import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.secondary900,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Buscar título',
                hintStyle: TextStyle(color: AppColors.white.withOpacity(0.65)),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
