import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const name = 'login--screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login PRUEBA', style: TextStyle(fontSize: 18))),
    );
  }
}
