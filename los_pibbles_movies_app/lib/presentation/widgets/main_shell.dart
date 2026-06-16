import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/presentation/screens/favorites/favorites_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/movies/home_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/search/search_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/settings/settings_screen.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.secondary900,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.white.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Búsqueda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
