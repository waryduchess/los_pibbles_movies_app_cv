import 'package:flutter/material.dart';

class CategoryFilterBar extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;
  final VoidCallback onFilterTap;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.onFilterTap,
  });

  @override
  State<CategoryFilterBar> createState() => _CategoryFilterBarState();
}

class _CategoryFilterBarState extends State<CategoryFilterBar> {
  int _selectedIndex = 0; // "Todos" está seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF6B4EFF);
    const darkElementBg = Color(0xFF1E1F35);

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          // Icono de filtro principal
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.tune, color: Colors.white54),
            onPressed: widget.onFilterTap,
          ),
          const SizedBox(width: 8),
          // Lista de categorías deslizable
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    widget.onCategorySelected(widget.categories[index]);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryPurple : darkElementBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}