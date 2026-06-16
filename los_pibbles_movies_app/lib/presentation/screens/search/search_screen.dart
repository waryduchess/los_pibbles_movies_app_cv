import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static const name = 'search--screen';

  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Búsqueda',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
