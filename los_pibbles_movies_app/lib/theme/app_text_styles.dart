import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Escala tipográfica optimizada para móvil usando Google Fonts (Inter).
class AppTextStyles {
  static TextStyle displayLg = GoogleFonts.inter(
    fontSize: 32, height: 40/32, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 24, height: 32/24, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
  );
  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 20, height: 28/20, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 16, height: 24/16, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14, height: 20/14, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12, height: 16/12, fontWeight: FontWeight.w500, color: AppColors.textMuted,
  );
}