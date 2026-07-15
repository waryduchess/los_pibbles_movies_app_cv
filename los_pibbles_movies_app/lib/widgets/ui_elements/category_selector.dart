import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/widgets/chips/tag_chip.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
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
          return GestureDetector(
            onTap: () => onSelected(category),
            child: TagChip(
              label: category,
              selected: selected,
              outlined: !selected,
            ),
          );
        },
      ),
    );
  }
}
