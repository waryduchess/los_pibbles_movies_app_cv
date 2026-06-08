import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final bool canCheckBiometrics = await _auth.canCheckBiometrics;
    final bool isSupported = await _auth.isDeviceSupported();
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    if (!canCheckBiometrics || !isSupported || availableBiometrics.isEmpty) {
      return false;
    }
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentícate con tu huella',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );
    } on Exception catch (e) {
      // Fail gracefully and return false on any platform exception
      return false;
    }
  }
}
