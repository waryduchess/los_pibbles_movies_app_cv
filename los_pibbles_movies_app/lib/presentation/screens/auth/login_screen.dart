import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/services/auth_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/biometric_auth_button.dart';
import 'package:los_pibbles_movies_app/widgets/gradient_background_widget.dart';
import 'package:los_pibbles_movies_app/widgets/input_widget.dart';
import 'package:los_pibbles_movies_app/widgets/button_widget.dart';
import 'package:los_pibbles_movies_app/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login--screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  void _checkSavedSession() {
    if (SessionManager.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/');
      });
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        SessionManager.setSession(
          result['userId'],
          result['userName'],
          foto: result['fotoPerfil'],
        );
        context.go('/');
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
          content: Text('Error de conexion: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary900,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: AppColors.secondary900),
          ),
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
                      const SizedBox(height: 40),

                      Center(
                        child: Image.asset(
                          'lib/resources/images/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const AppH1(
                        text: 'Pibble Movies',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      const AppBodySm(
                        text: 'Descubre y resume el cine',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      InputWidget(
                        label: 'Correo electronico *',
                        hintText: 'isa@email.com',
                        controller: _emailController,
                      ),

                      const SizedBox(height: 20),

                      InputWidget(
                        label: 'Contrasena *',
                        hintText: '........',
                        controller: _passwordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(
                          text: 'Olvidaste tu contrasena?',
                          textColor: AppColors.accent600,
                          type: ButtonType.tertiary,
                          onPressed: () {
                            context.push('/forgot-password');
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      ButtonWidget(
                        text: _isLoading ? 'Cargando...' : 'Iniciar Sesion',
                        type: ButtonType.primary,
                        onPressed: _isLoading ? () {} : _handleLogin,
                      ),

                      const SizedBox(height: 12),

                      ButtonWidget(
                        text: 'Registrarse',
                        type: ButtonType.secondary,
                        onPressed: () {
                          context.go('/register');
                        },
                      ),

                      const SizedBox(height: 32),

                      BiometricAuthButton(
                        onAuthenticated: () => context.go('/'),
                      ),

                      const SizedBox(height: 12),
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
