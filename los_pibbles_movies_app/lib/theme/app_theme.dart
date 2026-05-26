import 'package:flutter/material.dart';

//creamos una clase paraa agrupar las configuraciones de nuestro tema.
class AppTheme {
  //ThemeData es una clase que representa todas configuraciones visual de nuestra app
  //getTheme es una metodo que devuelve un objeto llamado themeData, pata utilizar en nuestra app
  ThemeData getTheme() => ThemeData(
    //useMaterial3 es una prpiedad que nos permite activar el material design 3
    useMaterial3: true,
    //colorSchemeSed es una propiedad que ayuda a definir los colores de nuestra app, ayuda
    // a definir una paleta de colores 0XFF2862F5
    colorSchemeSeed: const Color(0xFF4B39EF),
  );
}
