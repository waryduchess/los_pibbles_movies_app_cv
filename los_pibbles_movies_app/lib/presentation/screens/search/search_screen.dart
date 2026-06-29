import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/presentation/widgets/search_bar_widget.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class SearchScreen extends StatelessWidget {
  static const name = 'search--screen';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Búsqueda',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SearchBarWidget(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
