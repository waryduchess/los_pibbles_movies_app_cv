import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importamos tu Datasource modificado para MySQL
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart';

// Tus widgets globales de pasos de UI
import 'package:los_pibbles_movies_app/widgets/index.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const name = 'forgot-password--screen';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
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
  bool _isResetting = false;

  // Banderas de validación en tiempo real
  bool _hasLetter = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;
  bool _hasNoSpaces = true;
  bool _hasConfirmation = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePasswordRules);
    _confirmController.addListener(_validatePasswordRules);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _validatePasswordRules() {
    final pass = _passwordController.text;
    final confirm = _confirmController.text;

    setState(() {
      _hasLetter = RegExp(r'[a-zA-Z]').hasMatch(pass);
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(pass);
      _hasNumber = RegExp(r'[0-9]').hasMatch(pass);
      _hasMinLength = pass.length >= 8;
      _hasNoSpaces = !pass.contains(' ');
      _hasConfirmation = confirm.isNotEmpty;
      _passwordsMatch = pass.isNotEmpty && pass == confirm;
    });
  }

  bool _isPasswordFullyValid() {
    return _hasLetter && 
           _hasUppercase && 
           _hasNumber && 
           _hasMinLength && 
           _hasNoSpaces && 
           _hasConfirmation && 
           _passwordsMatch;
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

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      )
    );
  }

  Future<void> _checkEmail() async {
    final isValid = _emailFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    
    setState(() { _isLoadingEmail = true; _emailErrorMessage = null; });
    
    try {
      final email = _emailController.text.trim();
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

  Future<void> _resetPassword() async {
    if (!_isPasswordFullyValid()) {
      _showErrorSnackBar('Por favor, cumple con todos los requisitos de la contraseña.');
      return;
    }
    
    setState(() => _isResetting = true);

    try {
      final email = _emailController.text.trim();
      final newPassword = _passwordController.text.trim();
      
      await _authDatasource.forceUpdatePassword(email, newPassword);
      _nextPage(); 
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isResetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const scaffoldBgColor = Color(0xFF0B0C1A);

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
                  // PASO 1
                  EmailStep(
                    formKey: _emailFormKey,
                    controller: _emailController,
                    errorMessage: _emailErrorMessage,
                    isLoading: _isLoadingEmail,
                    onSubmit: _checkEmail,
                  ),
                  
                  // PASO 2: Nueva Contraseña
                  NewPasswordStep(
                    formKey: _passwordFormKey,
                    passwordController: _passwordController,
                    confirmController: _confirmController,
                    strengthText: "", 
                    strengthValue: 0.0,
                    strengthColor: Colors.transparent,
                    isLoading: _isResetting,
                    onSubmit: _resetPassword,
                    
                    // 📌 INYECTAMOS TU TARJETA AQUÍ COMO PARÁMETRO
                    validationWidget: ValidationCardWidget(
                      title: 'La contraseña debe cumplir:',
                      requirements: {
                        'Al menos una letra': _hasLetter,
                        'Al menos una letra mayúscula': _hasUppercase,
                        'Al menos un número': _hasNumber,
                        'Al menos 8 carácteres': _hasMinLength,
                        'Debe confirmar la contraseña': _hasConfirmation,
                        'Las contraseñas deben coincidir': _passwordsMatch,
                        'No debe contener espacios': _hasNoSpaces,
                      },
                    ),
                  ),
                  
                  // PASO 3
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