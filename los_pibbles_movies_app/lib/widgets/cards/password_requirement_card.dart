import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

class PasswordRequirementCard extends StatelessWidget {
  final bool hasLetter;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasMinLength;
  final bool confirmNotEmpty;
  final bool passwordsMatch;
  final bool hasNoSpaces;

  const PasswordRequirementCard({
    super.key,
    required this.hasLetter,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasMinLength,
    required this.confirmNotEmpty,
    required this.passwordsMatch,
    required this.hasNoSpaces,
  });

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.pets,
            size: 16,
            color: isMet ? Colors.green.shade600 : Colors.red.shade400,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isMet ? Colors.green.shade600 : Colors.red.shade400,
                fontSize: 14,
                fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background, // Usa el color de fondo de tu app
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.3), // Borde sutil
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "La contraseña debe cumplir los siguientes requerimientos:",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRequirementItem("Al menos una letra", hasLetter),
          _buildRequirementItem("Al menos una letra mayúscula", hasUppercase),
          _buildRequirementItem("Al menos un número", hasNumber),
          _buildRequirementItem("Al menos 8 carácteres", hasMinLength),
          _buildRequirementItem("Debe confirmar la contraseña", confirmNotEmpty),
          _buildRequirementItem("Las contraseñas deben coincidir", passwordsMatch),
          _buildRequirementItem("Las contraseñas no deben tener espacios", hasNoSpaces),
        ],
      ),
    );
  }
}