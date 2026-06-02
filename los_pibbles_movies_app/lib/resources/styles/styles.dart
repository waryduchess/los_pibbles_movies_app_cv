// lib/resources/styles/styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {

  // Font Families 
  static const String fontHeading = 'Plus Jakarta Sans';
  static const String fontBody    = 'Manrope';
  static const String fontButton  = 'DM Sans';

  // Font Sizes 
  static const double fontSizeH1      = 22;
  static const double fontSizeH2      = 17;
  static const double fontSizeH3      = 15;
  static const double fontSizeBody    = 14;
  static const double fontSizeBodySm  = 13;
  static const double fontSizeLabel   = 11;
  static const double fontSizeButton  = 14;

  //  Font Weights 
  static const FontWeight weightRegular  = FontWeight.w400;
  static const FontWeight weightMedium   = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold     = FontWeight.w700;

  //  Line Heights 
  static const double lineHeightTight   = 1.2; // H1
  static const double lineHeightNormal  = 1.4; // H2, H3, Label
  static const double lineHeightRelaxed = 1.6; // Body, BodySm
  static const double lineHeightFlat    = 1.0; // Button

  //  Letter Spacing 
  static const double letterSpacingNone   = 0.0;
  static const double letterSpacingLabel  = 0.8;
  static const double letterSpacingButton = 0.3;

  //  Text Styles 

  // Títulos de pantalla — "Pibble Movies"
  static final TextStyle h1 = GoogleFonts.plusJakartaSans(
    fontSize:      fontSizeH1,
    fontWeight:    weightBold,
    height:        lineHeightTight,
    letterSpacing: letterSpacingNone,
  );

  // Header de sección — "Crear Cuenta"
  static final TextStyle h2 = GoogleFonts.plusJakartaSans(
    fontSize:      fontSizeH2,
    fontWeight:    weightSemiBold,
    height:        lineHeightNormal,
    letterSpacing: letterSpacingNone,
  );

  // Subtítulos — nombres de usuario, secciones
  static final TextStyle h3 = GoogleFonts.plusJakartaSans(
    fontSize:      fontSizeH3,
    fontWeight:    weightMedium,
    height:        lineHeightNormal,
    letterSpacing: letterSpacingNone,
  );

  // Texto de inputs y contenido principal
  static final TextStyle body = GoogleFonts.manrope(
    fontSize:      fontSizeBody,
    fontWeight:    weightRegular,
    height:        lineHeightRelaxed,
    letterSpacing: letterSpacingNone,
  );

  // Textos secundarios — subtítulos, descripciones
  static final TextStyle bodySm = GoogleFonts.manrope(
    fontSize:      fontSizeBodySm,
    fontWeight:    weightRegular,
    height:        lineHeightRelaxed,
    letterSpacing: letterSpacingNone,
  );

  // Labels de inputs — "Correo electrónico *"
  static final TextStyle label = GoogleFonts.manrope(
    fontSize:      fontSizeLabel,
    fontWeight:    weightMedium,
    height:        lineHeightNormal,
    letterSpacing: letterSpacingLabel,
  );

  // Todos los botones — "Iniciar Sesión", "Registrarse"
  static final TextStyle button = GoogleFonts.dmSans(
    fontSize:      fontSizeButton,
    fontWeight:    weightSemiBold,
    height:        lineHeightFlat,
    letterSpacing: letterSpacingButton,
  );
}