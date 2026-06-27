import 'package:flutter/material.dart';
import '../../resources/color/colors.dart';

class GradientBackgroundWidget extends StatelessWidget {
  const GradientBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo base
        Container(color: AppColors.secondary900),

        // Degradado rosa
        Positioned(
          right: 0,
          top: 0,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.6, 0.4),
                radius: 1.063,
                colors: [
                  AppColors.accent500.withOpacity(0.07),
                  Colors.transparent,
                ],
                stops: const [0, 0.5],
              ),
            ),
          ),
        ),

        // Degradado morado
        Positioned(
          left: 0,
          top: 0,
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.6, -0.4),
                radius: 1.063,
                colors: [
                  AppColors.primary600.withOpacity(0.094),
                  Colors.transparent,
                ],
                stops: const [0, 0.55],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
