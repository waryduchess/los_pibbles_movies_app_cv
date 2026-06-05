//Importamos goRouter para manejar la navegacion de la App.
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/presentation/screens/screen.dart';

//Al usar goRouter nos ayuda mucho a que nosostros no tengamos que hacer config
//especial mentel si lo queremos usar en la web
//Creamos la configuracion global de router Define como navegamos en pantallas
final appRouter = GoRouter(
  //esto nos ayuuda a definir una pantalla al iniciar o abrir la App
  initialLocation: '/login',
  //Lista de rutas disponibles en la app
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      //esto es la URL de la ruta
      path: '/login',
      //esto es el nombre de la ruta
      name: LoginScreen.name,
      //esto es el widget de la ruta que se mostrara cuando entremos
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      //esto es la URL de la ruta
      path: '/register',
      //esto es el nombre de la ruta
      name: RegisterScreen.name,
      //esto es el widget de la ruta que se mostrara cuando entremos
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
