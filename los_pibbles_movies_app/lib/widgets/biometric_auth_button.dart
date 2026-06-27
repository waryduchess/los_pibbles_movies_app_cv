import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class BiometricAuthButton extends StatefulWidget {
  final VoidCallback? onAuthenticated;

  const BiometricAuthButton({super.key, this.onAuthenticated});

  @override
  State<BiometricAuthButton> createState() => _BiometricAuthButtonState();
}

class _BiometricAuthButtonState extends State<BiometricAuthButton> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final isDeviceSupported = await _localAuth.canCheckBiometrics;
      if (!mounted) return;

      setState(() {
        _isBiometricAvailable = isDeviceSupported;
      });
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
    }
  }

  Future<void> _authenticateWithBiometric() async {
    if (!_isBiometricAvailable) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric no disponible')),
      );
      return;
    }

    try {
      setState(() => _isAuthenticating = true);

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Autentica con tu huella digital',
        biometricOnly: true,
      );

      if (isAuthenticated && mounted) {
        widget.onAuthenticated?.call();
      }
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _isAuthenticating ? null : _authenticateWithBiometric,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.dividerColor),
        ),
        child: _isAuthenticating
            ? const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.fingerprint,
                size: 32,
                color: _isBiometricAvailable
                    ? AppColors.primary500
                    : theme.disabledColor,
              ),
      ),
    );
  }
}
