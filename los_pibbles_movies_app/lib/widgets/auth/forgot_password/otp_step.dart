import 'package:flutter/material.dart';
import '../../common/cr_button.dart';
import '../../cards/cr_message_card.dart';

class OtpStep extends StatelessWidget {
  final String email;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final AnimationController shakeController;
  final String? errorMessage;
  final bool isLoading;
  final int resendCountdown;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;

  const OtpStep({
    super.key,
    required this.email,
    required this.controllers,
    required this.focusNodes,
    required this.shakeController,
    this.errorMessage,
    required this.isLoading,
    required this.resendCountdown,
    required this.onVerify,
    required this.onResend,
    required this.onChangeEmail,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.vpn_key_outlined, size: 48, color: colors.primary),
          const SizedBox(height: 16),
          Text(
            "Verifica tu correo", 
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          
          CrMessageCard(
            message: "Te enviamos un código a $email",
            isError: false,
          ),
          const SizedBox(height: 32),
          
          AnimatedBuilder(
            animation: shakeController,
            builder: (context, child) {
              final dx = shakeController.isAnimating ? (10 * (0.5 - (0.5 - shakeController.value).abs())) : 0.0;
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  height: 56,
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "", 
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.primary, width: 2)),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) focusNodes[index + 1].requestFocus();
                      if (value.isEmpty && index > 0) focusNodes[index - 1].requestFocus();
                    },
                  ),
                );
              }),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 16),
            CrMessageCard(message: errorMessage!, isError: true),
          ],
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: resendCountdown > 0 ? null : onResend,
              child: Text(resendCountdown > 0 ? "Reenviar (${resendCountdown}s)" : "Reenviar código"),
            ),
          ),
          Center(child: TextButton(onPressed: onChangeEmail, child: const Text("Cambiar correo"))),
          const Spacer(),
          
          CrButton(
            label: "Verificar código", 
            isLoading: isLoading, 
            onPressed: onVerify,
          ),
        ],
      ),
    );
  }
}