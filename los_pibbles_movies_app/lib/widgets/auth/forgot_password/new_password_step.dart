import 'package:flutter/material.dart';
import '../../common/cr_button.dart';
import '../../inputs/cr_text_field.dart';

class NewPasswordStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final String strengthText;
  final double strengthValue;
  final Color strengthColor;
  final bool isLoading;
  final VoidCallback onSubmit;
  final Widget? validationWidget;

  const NewPasswordStep({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmController,
    required this.strengthText,
    required this.strengthValue,
    required this.strengthColor,
    required this.isLoading,
    required this.onSubmit,
    this.validationWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_outline, size: 48, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              "Crea una nueva contraseña", 
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 32),
            
            CrTextField(
              controller: passwordController,
              obscureText: true,
              label: "Nueva contraseña",
              validator: (value) {
                // 📌 Corregido el error tipográfico aquí (tenía una "a" suelta)
                if (value == null || value.length < 8) return "Debe tener al menos 8 caracteres";
                if (!value.contains(RegExp(r'[A-Za-z]')) || !value.contains(RegExp(r'[0-9]'))) return "Debe combinar letras y números";
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: strengthValue, 
                    color: strengthColor, 
                    backgroundColor: colors.surfaceContainerHighest
                  )
                ),
                const SizedBox(width: 8),
                Text(
                  strengthText, 
                  style: TextStyle(color: strengthColor, fontSize: 12, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            CrTextField(
              controller: confirmController,
              obscureText: true,
              label: "Confirmar contraseña",
              validator: (value) {
                if (value != passwordController.text) return "Las contraseñas no coinciden";
                return null;
              },
            ),
            
            // 📌 El Spacer empuja todo lo que está debajo hacia el fondo
            const SizedBox(height: 16),
            
            // 📌 Pinta la tarjeta de validación SOLO si existe, justo arriba del botón
            if (validationWidget != null) ...[
              validationWidget!,
              const SizedBox(height: 16), // Espacio de separación con el botón
            ],
            
            CrButton(
              label: "Restablecer contraseña", 
              isLoading: isLoading, 
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}