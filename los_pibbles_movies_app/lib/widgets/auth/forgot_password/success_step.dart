import 'package:flutter/material.dart';
import '../../common/cr_button.dart';

class SuccessStep extends StatelessWidget {
  final VoidCallback onGoToLogin;

  const SuccessStep({super.key, required this.onGoToLogin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: Icon(Icons.check_circle, size: 100, color: Colors.green.shade400));
            },
          ),
          const SizedBox(height: 24),
          Text(
            "¡Contraseña actualizada!", 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          const Text("Tu contraseña ha sido restablecida con éxito.", textAlign: TextAlign.center),
          const Spacer(),
          
          CrButton(
            label: "Ir a iniciar sesión", 
            isLoading: false, 
            onPressed: onGoToLogin,
          ),
        ],
      ),
    );
  }
}