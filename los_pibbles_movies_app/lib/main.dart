import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/router/app_router.dart';
import 'package:los_pibbles_movies_app/presentation/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'config/db/db_connection.dart'; // ajusta la ruta si hace falta

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBConnection.initialize(); // lee .env y prepara settings

  // Prueba de conexión rápida
  try {
    final conn = await DBConnection.getConnection();
    final results = await conn.query('SELECT COUNT(*) AS total FROM usuarios;');
    final total = results.isNotEmpty ? results.first['total'] : 0;
    print('Query result: $total');
    await conn.close();
  } catch (e) {
    print('Test de conexión falló: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //.router es una navegacion mas moderna, haciendo en automatico la navegacion
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()..loadMovies()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter, //sistema de ruta que usaremos
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
