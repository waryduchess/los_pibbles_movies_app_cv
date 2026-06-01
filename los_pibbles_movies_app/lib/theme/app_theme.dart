import 'package:flutter/material.dart';
import 'app_colors.dart';

//creamos una clase paraa agrupar las configuraciones de nuestro tema.
class AppTheme {
  //ThemeData es una clase que representa todas configuraciones visual de nuestra app
  //getTheme es una metodo que devuelve un objeto llamado themeData, pata utilizar en nuestra app
  ThemeData getTheme() => ThemeData(
    //useMaterial3 es una prpiedad que nos permite activar el material design 3
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary500,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary500,
      onSecondary: AppColors.white,
      surface: AppColors.black,
      onSurface: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      tertiary: AppColors.accent500,
      onTertiary: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.black,
    cardColor: AppColors.secondary900,
  );
}
