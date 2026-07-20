import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/domain/providers/comments_provider.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'package:provider/provider.dart';
import 'package:los_pibbles_movies_app/widgets/index.dart';


class SettingsScreen extends StatefulWidget {
  static const name = 'settings--screen';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _biometricEnabled = false;

  String? get _fotoPerfil => SessionManager.fotoPerfil;
  String? get _userName => SessionManager.userName;
  String? get _userEmail => SessionManager.userEmail ;
  String? get _memberSince => SessionManager.memberSince;
  int get _favoritesCount => SessionManager.favoritesCount ?? 0;

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
      final userId = SessionManager.userId!;
      await ProfileService.updatePhoto(userId, imageFile);
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
    await ProfileService.logout();
    if (mounted) {
      context.read<CommentsProvider>().clearLocalState();
      context.go('/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    // 📌 Formateamos la fecha para que solo muestre el día y no la hora completa
    String formattedDate = 'Fecha desconocida';
    if (_memberSince != null) {
      formattedDate = 'Miembro desde ${_memberSince!.split(' ')[0]}';
    }

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
                      userName: _userName ?? 'Usuario',
                      email: _userEmail ?? 'Sin correo registrado',
                      memberSince: formattedDate,
                      favoritesCount: _favoritesCount.toString(),
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
                        // 👇 1. Agregamos async y setState para que recargue al cambiar el correo
                        onTap: () async {
                          final success = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ChangeEmailDialog(),
                          );
                          // Si el diálogo devuelve true (se guardó con éxito), recargamos la pantalla
                          if (success == true) {
                            setState(() {}); 
                          }
                        },
                      ),
                      MenuItemData(
                        icon: Icons.lock_outline,
                        iconColor: Colors.greenAccent,
                        title: 'Cambiar contraseña',
                        onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ChangePasswordDialog(),
                            );
                          },
                      ),
                      MenuItemData(
                        icon: Icons.edit_outlined,
                        iconColor: AppColors.primary500,
                        title: 'Cambiar nombre y apellido',
                        // 👇 2. Agregamos async y setState para que recargue al cambiar el nombre
                        onTap: () async {
                          final success = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const ChangeNameDialog(),
                          );
                          // Si el diálogo devuelve true, recargamos la pantalla
                          if (success == true) {
                            setState(() {});
                          }
                        },
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
                        icon: Icons.description_outlined,
                        iconColor: Colors.grey,
                        title: 'Términos y privacidad',
                        onTap: () {
                          context.push('/terms');
                        },
                      ),
                    ]),
                    const SizedBox(height: 28),

                    LogoutButtonWidget(
                      onPressed: () {
                       showLogoutDialog(
                       context: context,
                       onConfirm: _logout,
                      );
                    },
                        ),
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
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