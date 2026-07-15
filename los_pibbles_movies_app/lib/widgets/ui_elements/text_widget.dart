// lib/widgets/text_widget.dart

import 'package:flutter/material.dart';
import '../../resources/styles/styles.dart';

// H1 — Títulos de pantalla 
// Uso: AppH1(text: 'Pibble Movies')
class AppH1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const AppH1({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppStyles.h1.copyWith(color: color),
    );
  }
}

// H2 — Headers de sección 
// Uso: AppH2(text: 'Crear Cuenta')
class AppH2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const AppH2({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppStyles.h2.copyWith(color: color),
    );
  }
}

// H3 — Subtítulos 
// Uso: AppH3(text: 'Reseñas recientes')
class AppH3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const AppH3({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppStyles.h3.copyWith(color: color),
    );
  }
}

// Body — Texto principal 
// Uso: AppBody(text: 'Descubre y resume el cine')
class AppBody extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppBody({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: AppStyles.body.copyWith(color: color),
    );
  }
}

// BodySm — Texto secundario 
// Uso: AppBodySm(text: '¿Olvidaste tu contraseña?')
class AppBodySm extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppBodySm({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: AppStyles.bodySm.copyWith(color: color),
    );
  }
}

// Label — Labels de inputs 
// Uso: AppLabel(text: 'Correo electrónico *')
class AppLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const AppLabel({
    super.key,
    required this.text,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppStyles.label.copyWith(color: color),
    );
  }
}