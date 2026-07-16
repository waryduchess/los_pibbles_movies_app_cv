import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final emailCtrl = TextEditingController();
  bool isLoading = false;
  
  bool _isTypingCorreo = false, _correoValid = false;

  @override
  void initState() {
    super.initState();
    emailCtrl.addListener(_validateCorreo);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _validateCorreo() => setState(() {
    _isTypingCorreo = emailCtrl.text.isNotEmpty;
    _correoValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailCtrl.text.trim());
  });

  Future<void> _submit() async {
    final newEmail = emailCtrl.text.trim();
    if (!_correoValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      await ProfileService.changeEmail(
        userId: SessionManager.userId!,
        newEmail: newEmail,
      );
      SessionManager.userEmail = newEmail;
      if (mounted) {
        Navigator.pop(context, true); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo actualizado'), backgroundColor: Colors.green),
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
    final bool showCorreoValidation = _isTypingCorreo && !_correoValid;

    return AlertDialog(
      backgroundColor: AppColors.secondary900,
      title: const Text('Actualizar Correo', style: TextStyle(color: AppColors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: AppColors.white),
            decoration: const InputDecoration(
              labelText: 'Nuevo correo electrónico',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
          if (showCorreoValidation)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ValidationCardWidget(
                title: "Requisitos del correo:",
                requirements: {"Formato de correo válido (@ y dominio)": _correoValid},
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context, false),
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