import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/checkbox_widget.dart';
import '../../widgets/gradient_background_widget.dart';
import '../../widgets/input_widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class RegisterScreen extends StatefulWidget {
  static const name = 'register--screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary900,
      appBar: AppBar(
        backgroundColor: AppColors.secondary900,
        elevation: 0,
        leading: const BackButtonWidget(route: '/login'),

        // H2 — Header de pantalla
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
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Apellido(s) *',
                        hintText: 'Pérez Rivas',
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Correo electrónico *',
                        hintText: 'isa@email.com',
                        controller: TextEditingController(),
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Contraseña *',
                        hintText: '••••••••',
                        controller: TextEditingController(),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Confirmar contraseña *',
                        hintText: '••••••••',
                        controller: TextEditingController(),
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
                        text: 'Registrarse',
                        type: ButtonType.primary,
                        onPressed: () => context.go('/login'),
                      ),
                      const SizedBox(height: 16),

                      ButtonWidget(
                        text: '¿Ya tienes cuenta? Inicia sesión',
                        type: ButtonType.tertiary,
                        onPressed: () => context.go('/login'),
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