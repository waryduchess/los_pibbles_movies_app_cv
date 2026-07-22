import 'dart:io';
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart';
import 'package:los_pibbles_movies_app/domain/services/auth_service.dart';
import 'package:los_pibbles_movies_app/domain/services/cloudinary_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';

class ProfileService {
  ProfileService._();

  static Future<String> updatePhoto(int userId, File imageFile) async {
    final url = await CloudinaryService.uploadImage(imageFile);
    final datasource = AuthBackendDatasource();
    await datasource.updateProfilePhoto(userId, url);
    SessionManager.fotoPerfil = url;
    return url;
  }

  static Future<void> logout() async {
    await AuthService.logoutGoogle();
    SessionManager.clear();
  }
  
  // 📌 1. Establecer contraseña (para cuentas Google, sin validar actual)
  static Future<void> setPassword({
    required int userId,
    required String newPassword,
  }) async {
    final datasource = AuthBackendDatasource();
    await datasource.setPassword(userId, newPassword);
  }

  // 📌 1b. Cambiar Contraseña (validando la actual)
  static Future<void> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final datasource = AuthBackendDatasource();
    await datasource.changePasswordWithValidation(
      userId, 
      currentPassword, 
      newPassword,
    );
  }

  // 📌 2. Cambiar Nombre y Apellidos
  static Future<void> changeNameAndSurname({
    required int userId,
    required String nombres,
    required String apellidos,
  }) async {
    final datasource = AuthBackendDatasource();
    await datasource.updateNameAndSurname(userId, nombres, apellidos);
    
    // Actualizamos la sesión local para que la UI se refresque de inmediato
    SessionManager.userName = '$nombres $apellidos';
  }

  // 📌 3. Cambiar Correo Electrónico
  static Future<void> changeEmail({
    required int userId,
    required String newEmail,
  }) async {
    final datasource = AuthBackendDatasource();
    await datasource.updateEmail(userId, newEmail);
    
    // Si tienes guardado el correo en tu SessionManager, descomenta la siguiente línea:
    // SessionManager.userEmail = newEmail;
  }
}