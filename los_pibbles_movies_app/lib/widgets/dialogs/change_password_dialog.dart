import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  bool isLoading = false;

  // Estados de validación solo para la NUEVA contraseña
  bool _isTypingPassword = false, _hasLetter = false, _hasUppercase = false, _hasNumber = false, _hasMinLength = false, _hasNoSpaces = true, _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    newPasswordCtrl.addListener(_validatePassword);
    confirmPasswordCtrl.addListener(_validatePassword);
  }

  @override
  void dispose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _validatePassword() => setState(() {
    final pass = newPasswordCtrl.text;
    final confirm = confirmPasswordCtrl.text;
    _isTypingPassword = pass.isNotEmpty || confirm.isNotEmpty;
    _hasLetter = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]').hasMatch(pass);
    _hasUppercase = RegExp(r'[A-ZÁÉÍÓÚÑ]').hasMatch(pass);
    _hasNumber = RegExp(r'[0-9]').hasMatch(pass);
    _hasMinLength = pass.length >= 8;
    _hasNoSpaces = pass.isNotEmpty && !pass.contains(' ');
    _passwordsMatch = pass.isNotEmpty && pass == confirm;
  });

  Future<void> _submit() async {
    final current = currentPasswordCtrl.text.trim();
    final newPass = newPasswordCtrl.text;

    if (current.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu contraseña actual'), backgroundColor: AppColors.error),
      );
      return;
    }

    if (!_hasLetter || !_hasUppercase || !_hasNumber || !_hasMinLength || !_hasNoSpaces || !_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La nueva contraseña no cumple los requisitos'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await ProfileService.changePassword(
        userId: SessionManager.userId!,
        currentPassword: current,
        newPassword: newPass,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña actualizada con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showPasswordValidation = _isTypingPassword && !(_hasLetter && _hasUppercase && _hasNumber && _hasMinLength && _hasNoSpaces && _passwordsMatch);

    return AlertDialog(
      backgroundColor: AppColors.secondary900,
      title: const Text('Cambiar Contraseña', style: TextStyle(color: AppColors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordCtrl,
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordCtrl,
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordCtrl,
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            if (showPasswordValidation)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ValidationCardWidget(
                  title: "La contraseña debe cumplir:",
                  requirements: {
                    "Al menos una letra": _hasLetter,
                    "Al menos una letra mayúscula": _hasUppercase,
                    "Al menos un número": _hasNumber,
                    "Al menos 8 carácteres": _hasMinLength,
                    "Debe confirmar la contraseña": confirmPasswordCtrl.text.isNotEmpty,
                    "Las contraseñas deben coincidir": _passwordsMatch,
                    "No debe contener espacios": _hasNoSpaces,
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary500),
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}