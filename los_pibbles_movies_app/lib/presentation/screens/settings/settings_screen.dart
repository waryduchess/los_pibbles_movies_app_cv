import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pibbles_movies_app/domain/datasources/auth_backend_datasource.dart';
import 'package:los_pibbles_movies_app/domain/services/cloudinary_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:los_pibbles_movies_app/widgets/settings/biometric_card_widget.dart';
import 'package:los_pibbles_movies_app/widgets/settings/menu_card_widget.dart';
import 'package:los_pibbles_movies_app/widgets/settings/profile_card_widget.dart';
import 'package:los_pibbles_movies_app/widgets/settings/section_label_widget.dart';
import 'package:los_pibbles_movies_app/widgets/logout_button_widget.dart';

class SettingsScreen extends StatefulWidget {
  static const name = 'settings--screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  final AuthBackendDatasource _datasource = AuthBackendDatasource();
  bool _isUploading = false;
  bool _biometricEnabled = false;

  String? get _fotoPerfil => SessionManager.fotoPerfil;
  String? get _userName => SessionManager.userName;

  void _viewPhotoFullScreen() {
    final foto = _fotoPerfil;
    if (foto == null || foto.isEmpty) return;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Stack(
        children: [
          Center(
            child: InteractiveViewer(
              maxScale: 4,
              child: Image.network(foto, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadPhoto() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final imageFile = File(picked.path);
      final url = await CloudinaryService.uploadImage(imageFile);

      final userId = int.parse(SessionManager.userId!);
      await _datasource.updateProfilePhoto(userId, url);

      SessionManager.fotoPerfil = url;
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _logout() async {
    SessionManager.clear();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1000,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    ProfileCardWidget(
                      userName: _userName ?? 'Isabel Zacarias',
                      email: 'isabel@gmail.com',
                      memberSince: 'Miembro desde mar. 2024',
                      favoritesCount: '0',
                      isUploading: _isUploading,
                      fotoPerfil: _fotoPerfil,
                      onPhotoTap: _viewPhotoFullScreen,
                      onCameraTap: _pickAndUploadPhoto,
                    ),
                    const SizedBox(height: 24),
                    const SectionLabelWidget(text: 'CUENTA'),
                    const SizedBox(height: 8),
                    MenuCardWidget(items: [
                      MenuItemData(
                        icon: Icons.mail_outline,
                        iconColor: AppColors.primary500,
                        title: 'Correo electrónico',
                        subtitle: null,
                        onTap: () {},
                      ),
                      MenuItemData(
                        icon: Icons.lock_outline,
                        iconColor: Colors.greenAccent,
                        title: 'Cambiar contraseña',
                        onTap: () {},
                      ),
                      MenuItemData(
                        icon: Icons.edit_outlined,
                        iconColor: AppColors.primary500,
                        title: 'Cambiar nombre y apellido',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 20),
                    const SectionLabelWidget(text: 'SEGURIDAD'),
                    const SizedBox(height: 8),
                    BiometricCardWidget(
                      enabled: _biometricEnabled,
                      onChanged: (value) {
                        setState(() => _biometricEnabled = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    const SectionLabelWidget(text: 'SOPORTE'),
                    const SizedBox(height: 8),
                    MenuCardWidget(items: [
                      MenuItemData(
                        icon: Icons.chat_bubble_outline,
                        iconColor: AppColors.error,
                        title: 'Enviar comentarios',
                        onTap: () {},
                      ),
                      MenuItemData(
                        icon: Icons.description_outlined,
                        iconColor: Colors.grey,
                        title: 'Términos y privacidad',
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 28),
                    LogoutButtonWidget(onPressed: _logout),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 8),
          const Row(
            children: [
              SizedBox(width: 8),
              Text(
                'Perfil',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
