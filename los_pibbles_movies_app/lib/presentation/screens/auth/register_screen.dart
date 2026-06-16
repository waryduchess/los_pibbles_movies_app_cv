import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/services/auth_service.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/back_button_widget.dart';
import 'package:los_pibbles_movies_app/widgets/checkbox_widget.dart';
import 'package:los_pibbles_movies_app/widgets/gradient_background_widget.dart';
import 'package:los_pibbles_movies_app/widgets/input_widget.dart';
import 'package:los_pibbles_movies_app/widgets/button_widget.dart';
import 'package:los_pibbles_movies_app/widgets/text_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'register--screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        _nombresController.text.trim(),
        _apellidosController.text.trim(),
        _correoController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada exitosamente. Inicia sesión.'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        backgroundColor: AppColors.secondary900,
        elevation: 0,
        leading: const BackButtonWidget(route: '/login'),

        title: const AppH2(
          text: 'Crear Cuenta',
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

                      InputWidget(
                        label: 'Nombre(s) *',
                        hintText: 'Juan Manuel',
                        controller: _nombresController,
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Apellido(s) *',
                        hintText: 'Pérez Rivas',
                        controller: _apellidosController,
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Correo electrónico *',
                        hintText: 'isa@email.com',
                        controller: _correoController,
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Contraseña *',
                        hintText: '••••••••',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Confirmar contraseña *',
                        hintText: '••••••••',
                        controller: _confirmPasswordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      CheckboxWidget(
                        value: _termsAccepted,
                        label: 'Acepto los términos y condiciones',
                        onChanged: (value) =>
                            setState(() => _termsAccepted = value ?? false),
                      ),
                      const SizedBox(height: 24),

                      ButtonWidget(
                        text: _isLoading ? 'Cargando...' : 'Registrarse',
                        type: ButtonType.primary,
                        onPressed: _isLoading ? () {} : _handleRegister,
                      ),
                      const SizedBox(height: 16),

                      ButtonWidget(
                        text: '¿Ya tienes cuenta? Inicia sesión',
                        type: ButtonType.tertiary,
                        onPressed: _isLoading ? () {} : () => context.go('/login'),
                        textColor: AppColors.accent600,
                      ),
                      const SizedBox(height: 32),

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
