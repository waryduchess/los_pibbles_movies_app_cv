import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie.dart';
import 'package:los_pibbles_movies_app/domain/entities/movie_actor.dart';
import 'package:los_pibbles_movies_app/presentation/screens/screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/details/full_cast_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/settings/change_email_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/settings/change_password_screen.dart';
import 'package:los_pibbles_movies_app/presentation/screens/settings/change_name_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainShell(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(  
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/recover',
      name: ForgotPasswordScreen.name,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/terms',
      builder: (context, state) => const TermsScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    GoRoute(
      path: '/movie-detail',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailScreen(movie: movie);
      },
    ),

    GoRoute(
      path: '/movie',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailScreen(movie: movie);
      },
    ),

    GoRoute(
      path: '/full-cast',
      builder: (context, state) {
        final cast = state.extra as List<MovieActor>;
        return FullCastScreen(cast: cast);
      },
    ),

    GoRoute(
      path: '/change-email',
      builder: (context, state) => const ChangeEmailScreen(),
    ),

    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    GoRoute(
      path: '/change-name',
      builder: (context, state) => const ChangeNameScreen(),
    ),
  ],
);