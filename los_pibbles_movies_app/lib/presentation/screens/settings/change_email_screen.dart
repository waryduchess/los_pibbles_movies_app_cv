import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ChangeEmailScreen extends StatefulWidget {
  static const name = 'change-email--screen';

  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _confirmEmailCtrl = TextEditingController();

  bool _isLoading = false;

  bool _isTypingCorreo = false, _correoValid = false;
  bool _isTypingConfirm = false, _emailsMatch = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_validateCorreo);
    _confirmEmailCtrl.addListener(_validateConfirm);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _confirmEmailCtrl.dispose();
    super.dispose();
  }

  void _validateCorreo() => setState(() {
    _isTypingCorreo = _emailCtrl.text.isNotEmpty;
    _correoValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailCtrl.text.trim());
    _emailsMatch = _confirmEmailCtrl.text.isNotEmpty && _emailCtrl.text == _confirmEmailCtrl.text;
  });

  void _validateConfirm() => setState(() {
    _isTypingConfirm = _confirmEmailCtrl.text.isNotEmpty;
    _emailsMatch = _confirmEmailCtrl.text.isNotEmpty && _emailCtrl.text == _confirmEmailCtrl.text;
  });

  Future<void> _submit() async {
    final newEmail = _emailCtrl.text.trim();
    if (!_correoValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido'), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_emailsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los correos no coinciden'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showCorreoValidation = _isTypingCorreo && !_correoValid;
    final bool showConfirmValidation = _isTypingConfirm && !_emailsMatch;

    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        backgroundColor: AppColors.secondary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
        ),
        title: const AppH2(text: 'Actualizar Correo', textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const GradientBackgroundWidget(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      InputWidget(
                        label: 'Nuevo correo electrónico *',
                        hintText: 'nuevo@email.com',
                        controller: _emailCtrl,
                      ),
                      if (showCorreoValidation)
                        ValidationCardWidget(
                          title: "Requisitos del correo:",
                          requirements: {"Formato de correo válido (@ y dominio)": _correoValid},
                        ),
                      const SizedBox(height: 16),
                      InputWidget(
                        label: 'Confirmar correo electrónico *',
                        hintText: 'nuevo@email.com',
                        controller: _confirmEmailCtrl,
                      ),
                      if (showConfirmValidation)
                        ValidationCardWidget(
                          title: "Confirmación de correo:",
                          requirements: {"Los correos coinciden": _emailsMatch},
                        ),
                      const SizedBox(height: 32),
                      ButtonWidget(
                        text: _isLoading ? 'Cargando...' : 'Guardar',
                        type: ButtonType.primary,
                        onPressed: _isLoading ? () {} : _submit,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
