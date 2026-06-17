import 'package:flutter/material.dart';
import '../../common/cr_button.dart';
import '../../inputs/cr_text_field.dart';
import '../../cards/cr_message_card.dart';

class EmailStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback onSubmit;

  const EmailStep({
    super.key,
    required this.formKey,
    required this.controller,
    this.errorMessage,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.mail_outline, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              "¿Olvidaste tu contraseña?", 
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            Text(
              "Ingresa tu correo electrónico y te enviaremos un código para restablecerla.", 
              style: Theme.of(context).textTheme.bodyMedium
            ),
            const SizedBox(height: 32),
            
            if (errorMessage != null) ...[
              CrMessageCard(message: errorMessage!, isError: true),
              const SizedBox(height: 16),
            ],
            
            CrTextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              label: "Correo electrónico",
              prefixIcon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) return "El correo es requerido";
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Correo electrónico inválido";
                return null;
              },
            ),
            const Spacer(),
            
            CrButton(
              label: "Enviar código",
              isLoading: isLoading, 
              onPressed: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}