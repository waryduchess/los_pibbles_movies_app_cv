import 'package:flutter/material.dart';
// Asegúrate de que esta ruta coincida con la ubicación real en tu proyecto
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    
    // Configuración completa del esquema de colores usando las variables del equipo
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary500,       // Su morado principal (0xFF9475FF)
      onPrimary: AppColors.white,
      secondary: AppColors.secondary500,   // Su tono secundario intermedio
      onSecondary: AppColors.white,
      surface: AppColors.secondary1000,    // El fondo oscuro profundo (0xFF0D0E17)
      onSurface: AppColors.white,
      error: AppColors.error,              // Su rojo de error (0xFFFF3B30)
      onError: AppColors.white,
      tertiary: AppColors.accent500,       // Su acento rosa (0xFFFF5C8A)
      onTertiary: AppColors.white,
    ),
    
    // Fondos e interfaces globales alineadas a sus escalas
    scaffoldBackgroundColor: AppColors.secondary1000, // Fondo base de la app
    cardColor: AppColors.secondary900,               // Fondo para tarjetas y contenedores (0xFF1A1B2E)
  );
}