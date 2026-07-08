import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/router/app_router.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/presentation/providers/favorites_provider.dart';
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
    print('Test de conexion fallo: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (SessionManager.userId != null && SessionManager.isExpired) {
        SessionManager.clear();
        appRouter.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider()..loadMovies()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(
            idUsuario: SessionManager.userId != null
                ? int.tryParse(SessionManager.userId!) ?? 0
                : 0,
          ),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
      ),
    );
  }
}
