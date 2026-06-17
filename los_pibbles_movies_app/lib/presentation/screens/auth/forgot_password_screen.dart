import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importamos tu Datasource modificado para MySQL
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart';

// Tus widgets globales de pasos de UI
import 'package:los_pibbles_movies_app/widgets/auth/forgot_password/email_step.dart';
import 'package:los_pibbles_movies_app/widgets/auth/forgot_password/new_password_step.dart';
import 'package:los_pibbles_movies_app/widgets/auth/forgot_password/success_step.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // 🚀 Instancia de tu Datasource enfocado en MySQL
  final AuthBackendDatasource _authDatasource = AuthBackendDatasource();

  // Estado Paso 1 (Email)
  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  bool _isLoadingEmail = false;
  String? _emailErrorMessage;

  // Estado Paso 2 (Nueva Contraseña)
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFormKey = GlobalKey<FormState>();
  String _passwordStrengthText = "Débil";
  double _passwordStrengthValue = 0.25;
  Color _passwordStrengthColor = Colors.red;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _evaluatePassword(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() => _currentPage++);
  }

  void _prevPage() {
    if (_currentPage == 0) {
      context.pop();
    } else if (_currentPage == 2) { 
      context.go('/login'); 
    } else {
      FocusScope.of(context).unfocus();
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  // --- Lógica: Paso 1 (Verificar Correo en MySQL) ---
  Future<void> _checkEmail() async {
    final isValid = _emailFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    
    setState(() { _isLoadingEmail = true; _emailErrorMessage = null; });
    
    try {
      final email = _emailController.text.trim();
      // 🚀 Consulta directa a MySQL a través de tu datasource híbrido
      final exists = await _authDatasource.checkEmailExists(email);
      
      if (exists) {
        _nextPage();
      } else {
        setState(() => _emailErrorMessage = 'Este correo no está registrado en el sistema.');
      }
    } catch (e) {
      setState(() => _emailErrorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() { _isLoadingEmail = false; });
    }
  }

  // --- Lógica: Paso 2 (Cambio de Contraseña mediante UPDATE a MySQL) ---
  Future<void> _resetPassword() async {
    final isValid = _passwordFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    
    setState(() => _isResetting = true);

    try {
      final email = _emailController.text.trim();
      final newPassword = _passwordController.text.trim();
      
      // 🚀 Ejecutamos el cambio aplicando el tratamiento hash definido en tu .env
      await _authDatasource.forceUpdatePassword(email, newPassword);
      
      _nextPage(); 
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: const Color(0xFF1E1F35),
          )
        );
      }
    } finally {
      setState(() => _isResetting = false);
    }
  }

  void _evaluatePassword(String value) {
    if (value.length < 8) {
      setState(() { _passwordStrengthText = "Débil"; _passwordStrengthValue = 0.25; _passwordStrengthColor = Colors.red; });
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      setState(() { _passwordStrengthText = "Aceptable"; _passwordStrengthValue = 0.50; _passwordStrengthColor = Colors.orange; });
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      setState(() { _passwordStrengthText = "Buena"; _passwordStrengthValue = 0.75; _passwordStrengthColor = Colors.lightGreen; });
    } else {
      setState(() { _passwordStrengthText = "Excelente"; _passwordStrengthValue = 1.0; _passwordStrengthColor = Colors.green; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Preservamos el color oscuro de tu interfaz por consistencia
    const scaffoldBgColor = Color(0xFF0B0C1A);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: _prevPage),
        title: const Text('Recuperar contraseña', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentPage + 1) / 3,
              backgroundColor: const Color(0xFF1E1F35),
              color: const Color(0xFF6B4EFF),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // PASO 1: Ingresar y Validar Correo
                  EmailStep(
                    formKey: _emailFormKey,
                    controller: _emailController,
                    errorMessage: _emailErrorMessage,
                    isLoading: _isLoadingEmail,
                    onSubmit: _checkEmail,
                  ),
                  
                  // PASO 2: Ingresar Nueva Contraseña
                  NewPasswordStep(
                    formKey: _passwordFormKey,
                    passwordController: _passwordController,
                    confirmController: _confirmController,
                    strengthText: _passwordStrengthText,
                    strengthValue: _passwordStrengthValue,
                    strengthColor: _passwordStrengthColor,
                    isLoading: _isResetting,
                    onSubmit: _resetPassword,
                  ),
                  
                  // PASO 3: Éxito
                  SuccessStep(onGoToLogin: () => context.go('/login')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}