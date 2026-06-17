import 'package:flutter/material.dart';

/// Logo oficial de Pibble Movies.
/// Reutilizable en Login, Splash, About, etc.
class CrAppLogo extends StatelessWidget {
  const CrAppLogo({
    super.key,
    this.size = 100,
    this.borderRadius = 16,
    this.elevated = true,
  });

  /// Lado del cuadrado en logical pixels (default 100).
  final double size;

  /// Radio de las esquinas (default 16).
  final double borderRadius;

  /// Si true, aplica la sombra dual del diseño Figma.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.20),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'lib/resources/images/pibble_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          semanticLabel: 'Logo Pibble Movies',
        ),
      ),
    );
  }
}