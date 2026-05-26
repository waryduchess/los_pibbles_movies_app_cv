import 'Package:flutter/material.dart';
//import 'Flutter widget Snippet

//stils
class HomeScreen extends StatelessWidget {
  //Constante golbal dentro de la clase que sirve para las rutas de navegacion (go_router)
  static const name =
      'home--screen'; //este es el nombre con el cual podremos llegar a los componentes
  //
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Placeholder());
  }
}
