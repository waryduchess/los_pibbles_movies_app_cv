import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
//import 'package:los_pibbles_movies_app/widgets/back_button_widget.dart';
//import 'package:los_pibbles_movies_app/widgets/checkbox_widget.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

                      // H1 — Título principal
                      const AppH1(
                        text: 'Pibble Movies',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // BodySm — Subtítulo
                      const AppBodySm(
                        text: 'Descubre y resume el cine',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 30),

                      InputWidget(
                        label: 'Correo electrónico *',
                        hintText: 'isa@email.com',
                        controller: _emailController,
                      ),

                      const SizedBox(height: 20),

                      InputWidget(
                        label: 'Contraseña *',
                        hintText: '••••••••',
                        controller: _passwordController,
                        obscureText: true,
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(
                          text: '¿Olvidaste tu contraseña?',
                          textColor: AppColors.accent600,
                          type: ButtonType.tertiary,
                          onPressed: () {},
                        ),
                      ),

                      const SizedBox(height: 12),

                      ButtonWidget(
                        text: 'Iniciar Sesión',
                        type: ButtonType.primary,
                        onPressed: () {},
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

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: const Icon(Icons.fingerprint, size: 32),
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
