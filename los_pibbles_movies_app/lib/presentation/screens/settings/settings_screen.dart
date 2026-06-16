import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'settings--screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ajustes',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
