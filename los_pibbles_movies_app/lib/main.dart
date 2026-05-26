import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/router/app_router.dart';
import 'package:los_pibbles_movies_app/theme/app_theme.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //.router es una navegacion mas moderna, haciendo en automatico la navegacion
    return MaterialApp.router(
      routerConfig: appRouter, //sistema de ruta que usaremos
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
