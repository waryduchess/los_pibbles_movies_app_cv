import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/router/app_router.dart';
import 'package:los_pibbles_movies_app/presentation/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'config/db/db_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBConnection.initialize();

  try {
    final conn = await DBConnection.getConnection();
    final results = await conn.execute('SELECT COUNT(*) AS total FROM usuarios');
    final total = results.rows.isNotEmpty ? results.rows.first.assoc()['total'] : '0';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()..loadMovies()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
