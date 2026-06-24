import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/services/auth_service.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/back_button_widget.dart';
import 'package:los_pibbles_movies_app/widgets/gradient_background_widget.dart';
import 'package:los_pibbles_movies_app/widgets/input_widget.dart';
import 'package:los_pibbles_movies_app/widgets/button_widget.dart';
import 'package:los_pibbles_movies_app/widgets/text_widget.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';

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
  
  bool _isLoading = false;

  // Estados de validación
  bool _isTypingNombres = false, _nombresNoNumbers = true, _nombresTitleCase = false;
  bool _isTypingApellidos = false, _apellidosNoNumbers = true, _apellidosTitleCase = false;
  bool _isTypingCorreo = false, _correoValid = false;
  bool _isTypingPassword = false, _hasLetter = false, _hasUppercase = false, _hasNumber = false, _hasMinLength = false, _hasNoSpaces = true, _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _nombresController.addListener(_validateNombres);
    _apellidosController.addListener(_validateApellidos);
    _correoController.addListener(_validateCorreo);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  bool _isStrictlyFormatted(String text) {
    if (text.trim().isEmpty) return false;
    for (String word in text.trim().split(RegExp(r'\s+'))) {
      if (word.isNotEmpty) {
        if (word != word[0].toUpperCase() + word.substring(1).toLowerCase()) return false;
      }
    }
    return true;
  }

  void _validateNombres() => setState(() {
    _isTypingNombres = _nombresController.text.isNotEmpty;
    _nombresNoNumbers = !RegExp(r'[0-9]').hasMatch(_nombresController.text);
    _nombresTitleCase = _isStrictlyFormatted(_nombresController.text);
  });

  void _validateApellidos() => setState(() {
    _isTypingApellidos = _apellidosController.text.isNotEmpty;
    _apellidosNoNumbers = !RegExp(r'[0-9]').hasMatch(_apellidosController.text);
    _apellidosTitleCase = _isStrictlyFormatted(_apellidosController.text);
  });

  void _validateCorreo() => setState(() {
    _isTypingCorreo = _correoController.text.isNotEmpty;
    _correoValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_correoController.text.trim());
  });

  void _validatePassword() => setState(() {
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    _isTypingPassword = pass.isNotEmpty || confirm.isNotEmpty;
    _hasLetter = RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]').hasMatch(pass);
    _hasUppercase = RegExp(r'[A-ZÁÉÍÓÚÑ]').hasMatch(pass);
    _hasNumber = RegExp(r'[0-9]').hasMatch(pass);
    _hasMinLength = pass.length >= 8;
    _hasNoSpaces = pass.isNotEmpty && !pass.contains(' ');
    _passwordsMatch = pass.isNotEmpty && pass == confirm;
  });

  Future<void> _handleRegister() async {
    final nombres = _nombresController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final apellidos = _apellidosController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final correo = _correoController.text.trim();
    final password = _passwordController.text;

    if (!_nombresNoNumbers || !_nombresTitleCase) return _showErrorSnackBar('Verifica el campo Nombres');
    if (!_apellidosNoNumbers || !_apellidosTitleCase) return _showErrorSnackBar('Verifica el campo Apellidos');
    if (!_correoValid) return _showErrorSnackBar('Ingresa un correo electrónico válido');
    if (!_hasLetter || !_hasUppercase || !_hasNumber || !_hasMinLength || !_hasNoSpaces || !_passwordsMatch) return _showErrorSnackBar('La contraseña no cumple los requisitos');

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.register(nombres, apellidos, correo, password);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cuenta creada exitosamente. Inicia sesión.'), backgroundColor: AppColors.success),
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
        title: const AppH2(text: 'Crear Cuenta', textAlign: TextAlign.center),
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
                      InputWidget(label: 'Nombre(s) *', hintText: 'Ej: Juan Manuel', controller: _nombresController),
                      if (_isTypingNombres) ValidationCardWidget(
                        title: "Requisitos del nombre:",
                        requirements: {"No debe contener números": _nombresNoNumbers, "Primera letra mayúscula, resto minúsculas": _nombresTitleCase},
                      ),
                      const SizedBox(height: 16),

                      InputWidget(label: 'Apellido(s) *', hintText: 'Ej: Pérez Rivas', controller: _apellidosController),
                      if (_isTypingApellidos) ValidationCardWidget(
                        title: "Requisitos de los apellidos:",
                        requirements: {"No debe contener números": _apellidosNoNumbers, "Primera letra mayúscula, resto minúsculas": _apellidosTitleCase},
                      ),
                      const SizedBox(height: 16),

                      InputWidget(label: 'Correo electrónico *', hintText: 'isa@email.com', controller: _correoController),
                      if (_isTypingCorreo) ValidationCardWidget(
                        title: "Requisitos del correo:",
                        requirements: {"Formato de correo válido (@ y dominio)": _correoValid},
                      ),
                      const SizedBox(height: 16),

                      InputWidget(label: 'Contraseña *', hintText: '••••••••', controller: _passwordController, obscureText: true),
                      const SizedBox(height: 16),
                      InputWidget(label: 'Confirmar contraseña *', hintText: '••••••••', controller: _confirmPasswordController, obscureText: true),
                      
                      if (_isTypingPassword) ValidationCardWidget(
                        title: "La contraseña debe cumplir:",
                        requirements: {
                          "Al menos una letra": _hasLetter,
                          "Al menos una letra mayúscula": _hasUppercase,
                          "Al menos un número": _hasNumber,
                          "Al menos 8 carácteres": _hasMinLength,
                          "Debe confirmar la contraseña": _confirmPasswordController.text.isNotEmpty,
                          "Las contraseñas deben coincidir": _passwordsMatch,
                          "No debe contener espacios": _hasNoSpaces,
                        },
                      ),
                      const SizedBox(height: 24),

                      // 📌 NUEVO TEXTO DE TÉRMINOS Y CONDICIONES CLIQUEABLE
                      GestureDetector(
                        onTap: () {
                          // Asegúrate de tener configurada la ruta '/terminos' en tu router
                          context.push('/terms'); 
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Al hacer clic en "Registrarse", aceptas nuestros ',
                              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                              children: [
                                TextSpan(
                                  text: 'Términos y Condiciones',
                                  style: TextStyle(
                                    color: AppColors.accent600, // Usa el color de acento de tu app
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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