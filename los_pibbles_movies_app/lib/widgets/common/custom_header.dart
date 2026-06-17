import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🚀 Importamos los colores oficiales de tu equipo
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

// Puedes mantener esta importación comentada o borrarla hasta verificar el nombre real de la clase
// import '../../resources/images/images_assets.dart';

class CustomHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const CustomHeader({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🌟 AVATAR / LOGO DE LA APP
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            // 🚀 Cambiamos la variable que daba error por la ruta en string.
            // (Asegúrate de que la imagen exista en tu carpeta assets y en pubspec.yaml)
            'resources/images/logo.png', 
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            // Si la ruta falla, mostramos un contenedor con un ícono para que no crashee
            errorBuilder: (context, error, stackTrace) => Container(
              width: 40, 
              height: 40, 
              color: AppColors.secondary800,
              child: const Icon(Icons.movie, color: AppColors.primary500),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 🌟 NOMBRE DEFINITIVO DE LA APP
        Text(
          'Pibble Movies', // 👈 Nombre definitivo
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.white, // 🚀 Color oficial
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const Spacer(),
        
        // 🌟 BOTÓN DE PERFIL 
        Container(
          decoration: const BoxDecoration(
            color: AppColors.secondary800, // 🚀 Fondo adaptado al tema oscuro del equipo
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.textSecondary, // 🚀 Gris oficial para los íconos
            ),
            onPressed: onProfileTap,
          ),
        ),
      ],
    );
  }
}