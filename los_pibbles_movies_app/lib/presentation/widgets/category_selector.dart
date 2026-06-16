import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/tag_chip.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == selectedCategory;
          return TagChip(
            label: category,
            selected: selected,
            outlined: !selected,
          );
        },
      ),
    );
  }
}
