import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:los_pibbles_movies_app/domain/entities/app_exception.dart';
import 'package:los_pibbles_movies_app/domain/services/auth_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/presentation/providers/favorites_provider.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';
import 'package:provider/provider.dart';

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
  bool _isGoogleLoading = false; // Estado para el botón de Google
  AppErrorType? _errorType;

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

  /// Maneja el inicio de sesión estándar con correo y contraseña
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
          int.parse(result['userId'].toString()),
          result['userName'],
          foto: result['fotoPerfil'],
        );
        final favProvider = context.read<FavoritesProvider>();
        await favProvider.loadFavoritesForUser(
          int.parse(result['userId'].toString()),
        );
        if (!mounted) return;
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
      if (e is AppException && e.type == AppErrorType.databaseError) {
        setState(() => _errorType = AppErrorType.databaseError);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de conexion: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Maneja el inicio de sesión con Google (Actualizado para V7)
  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);

    try {
      // 📌 Llamamos al nuevo método V7 que maneja authenticate()
      final result = await AuthService.loginWithGoogle();

      if (!mounted) return;
      setState(() => _isGoogleLoading = false);

      if (result['success'] == true) {
        // 📌 Usamos la estructura de datos que definimos en Turn 5: result['data']
        final userData = result['data'] as Map<String, dynamic>;
        
        SessionManager.setSession(
          int.parse((userData['userId'] ?? '0').toString()),
          userData['userName'] ?? 'Usuario de Google',
        );
        final favProvider = context.read<FavoritesProvider>();
        await favProvider.loadFavoritesForUser(
          int.parse((userData['userId'] ?? '0').toString()),
        );
        if (!mounted) return;
        context.go('/');
      } else {
        // Si el usuario cancela o hay un error controlado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['error']), 
            backgroundColor: AppColors.error
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGoogleLoading = false);
      if (e is AppException && e.type == AppErrorType.databaseError) {
        setState(() => _errorType = AppErrorType.databaseError);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error crítico de conexión: $e'), 
            backgroundColor: AppColors.error
          ),
        );
      }
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
    // Definimos si alguno de los botones está cargando para deshabilitar ambos
    final isAnyLoading = _isLoading || _isGoogleLoading;

    if (_errorType != null) {
      return Scaffold(
        backgroundColor: AppColors.secondary900,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: AppColors.secondary900),
            ),
            const GradientBackgroundWidget(),
            CrErrorState(
              type: _errorType!,
              onRetry: () => setState(() => _errorType = null),
            ),
          ],
        ),
      );
    }

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
                      const SizedBox(height: 38),

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

                      const SizedBox(height: 24),

                      InputWidget(
                        label: 'Correo electrónico *',
                        hintText: 'isa@email.com',
                        controller: _emailController,
                      ),

                      const SizedBox(height: 16),

                      InputWidget(
                        label: 'Contraseña *',
                        hintText: '........',
                        controller: _passwordController,
                        obscureText: true,
                      ),

                      //const SizedBox(height: 5),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ButtonWidget(
                          text: 'Olvidaste tu contraseña?',
                          textColor: AppColors.accent600,
                          type: ButtonType.tertiary,
                          onPressed: () {
                            context.push('/forgot-password');
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Botón de Iniciar Sesión (Estándar)
                      ButtonWidget(
                        text: _isLoading ? 'Cargando...' : 'Iniciar sesión',
                        type: ButtonType.primary,
                        // Deshabilitamos si alguno de los dos está cargando
                        onPressed: isAnyLoading ? () {} : _handleLogin,
                      ),

                      const SizedBox(height: 12),

                      ButtonWidget(
                        text: 'Registrarse',
                        type: ButtonType.secondary,
                        onPressed: () {
                          context.go('/register');
                        },
                      ),

                      const SizedBox(height: 10),

                      // Separador visual "o continúa con"
                     

                      //const SizedBox(height: 24),

                      // 📌 Botón de Google (CORREGIDO COMPLETO)
                      ElevatedButton.icon(
                        onPressed: isAnyLoading ? null : _handleGoogleLogin,
                        icon: _isGoogleLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            // 💡 SOLUCIÓN VISUAL: Usar la versión PNG del mismo logo de Wikimedia para evitar errores
                            : Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                                height: 24,
                              ), 
                        label: Text(
                          _isGoogleLoading ? 'Cargando...' : 'Continuar con Google',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13151D), // Un tono muy oscuro para tu diseño
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      // BiometricAuthButton se mantiene igual
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