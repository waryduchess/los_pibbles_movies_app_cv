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

  // Función de ayuda para mostrar los SnackBar de error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _handleRegister() async {
    final nombres = _nombresController.text.trim();
    final apellidos = _apellidosController.text.trim();
    final correo = _correoController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // 1. Validar que no haya campos vacíos
    if (nombres.isEmpty || apellidos.isEmpty || correo.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Por favor, completa todos los campos requeridos');
      return;
    }

    // 2. 🚀 VALIDACIÓN DE SOLO LETRAS (Acepta espacios, acentos y ñ)
    final nameRegExp = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegExp.hasMatch(nombres)) {
      _showErrorSnackBar('El nombre solo debe contener letras');
      return;
    }
    if (!nameRegExp.hasMatch(apellidos)) {
      _showErrorSnackBar('El apellido solo debe contener letras');
      return;
    }

    // 3. 🚀 VALIDACIÓN DE CORREO ELECTRÓNICO
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(correo)) {
      _showErrorSnackBar('Ingresa un correo electrónico válido');
      return;
    }

    // 4. Validar contraseñas
    if (password != confirmPassword) {
      _showErrorSnackBar('Las contraseñas no coinciden');
      return;
    }

    // 5. Validar términos y condiciones
    if (!_termsAccepted) {
      _showErrorSnackBar('Debes aceptar los términos y condiciones');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(
        nombres,
        apellidos,
        correo,
        password,
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
        _showErrorSnackBar(result['error']);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error de conexión: $e');
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