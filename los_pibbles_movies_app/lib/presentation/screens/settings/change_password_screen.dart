import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const name = 'change-password--screen';

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool _isLoading = false;

  bool _isTypingPassword = false, _hasLetter = false, _hasUppercase = false, _hasNumber = false, _hasMinLength = false, _hasNoSpaces = true, _passwordsMatch = false;

  bool get _isGoogle => SessionManager.isGoogleAccount;

  @override
  void initState() {
    super.initState();
    _newPasswordCtrl.addListener(_validatePassword);
    _confirmPasswordCtrl.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _validatePassword() => setState(() {
    final pass = _newPasswordCtrl.text;
    final confirm = _confirmPasswordCtrl.text;
    _isTypingPassword = pass.isNotEmpty || confirm.isNotEmpty;
    _hasLetter = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]').hasMatch(pass);
    _hasUppercase = RegExp(r'[A-ZÁÉÍÓÚÑ]').hasMatch(pass);
    _hasNumber = RegExp(r'[0-9]').hasMatch(pass);
    _hasMinLength = pass.length >= 8;
    _hasNoSpaces = pass.isNotEmpty && !pass.contains(' ');
    _passwordsMatch = pass.isNotEmpty && pass == confirm;
  });

  Future<void> _submit() async {
    final newPass = _newPasswordCtrl.text;

    if (!_isGoogle) {
      final current = _currentPasswordCtrl.text.trim();
      if (current.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa tu contraseña actual'), backgroundColor: AppColors.error),
        );
        return;
      }
    }

    if (!_hasLetter || !_hasUppercase || !_hasNumber || !_hasMinLength || !_hasNoSpaces || !_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La nueva contraseña no cumple los requisitos'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isGoogle) {
        await ProfileService.setPassword(
          userId: SessionManager.userId!,
          newPassword: newPass,
        );
        SessionManager.isGoogleAccount = false;
      } else {
        await ProfileService.changePassword(
          userId: SessionManager.userId!,
          currentPassword: _currentPasswordCtrl.text.trim(),
          newPassword: newPass,
        );
      }

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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showPasswordValidation = _isTypingPassword && !(_hasLetter && _hasUppercase && _hasNumber && _hasMinLength && _hasNoSpaces && _passwordsMatch);

    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        backgroundColor: AppColors.secondary900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
        title: AppH2(
          text: _isGoogle ? 'Establecer Contraseña' : 'Cambiar Contraseña',
          textAlign: TextAlign.center,
        ),
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
                      if (!_isGoogle)
                        InputWidget(
                          label: 'Contraseña actual *',
                          hintText: '••••••••',
                          controller: _currentPasswordCtrl,
                          obscureText: true,
                        ),
                      if (!_isGoogle) const SizedBox(height: 16),
                      InputWidget(
                        label: _isGoogle ? 'Nueva contraseña *' : 'Nueva contraseña *',
                        hintText: '••••••••',
                        controller: _newPasswordCtrl,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      InputWidget(
                        label: 'Confirmar nueva contraseña *',
                        hintText: '••••••••',
                        controller: _confirmPasswordCtrl,
                        obscureText: true,
                      ),
                      if (showPasswordValidation)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ValidationCardWidget(
                            title: "La contraseña debe cumplir:",
                            requirements: {
                              "Al menos una letra": _hasLetter,
                              "Al menos una letra mayúscula": _hasUppercase,
                              "Al menos un número": _hasNumber,
                              "Al menos 8 carácteres": _hasMinLength,
                              "Debe confirmar la contraseña": _confirmPasswordCtrl.text.isNotEmpty,
                              "Las contraseñas deben coincidir": _passwordsMatch,
                              "No debe contener espacios": _hasNoSpaces,
                            },
                          ),
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
