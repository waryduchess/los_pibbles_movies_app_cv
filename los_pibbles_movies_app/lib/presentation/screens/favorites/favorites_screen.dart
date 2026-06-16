import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  static const name = 'favorites--screen';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Favoritos',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
