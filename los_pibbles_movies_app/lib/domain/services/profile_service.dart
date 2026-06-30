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
}
