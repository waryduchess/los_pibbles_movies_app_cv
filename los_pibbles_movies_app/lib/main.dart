import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/config/router/app_router.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/domain/providers/favorites_provider.dart';
import 'package:los_pibbles_movies_app/domain/providers/comments_provider.dart';
import 'package:los_pibbles_movies_app/domain/providers/actor_provider.dart';
import 'package:los_pibbles_movies_app/domain/providers/movies_provider.dart';
import 'package:los_pibbles_movies_app/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'domain/infrastructure/db_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBConnection.initialize();
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
        ChangeNotifierProvider(create: (_) => ActorProvider()),
        ChangeNotifierProvider(create: (_) => CommentsProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              FavoritesProvider(idUsuario: SessionManager.userId ?? 0),
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
