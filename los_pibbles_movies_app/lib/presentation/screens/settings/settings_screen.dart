import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart'; // 👈 Importamos el paquete de video
import 'package:los_pibbles_movies_app/domain/services/profile_service.dart';
import 'package:los_pibbles_movies_app/domain/services/session_manager.dart';
import 'package:los_pibbles_movies_app/domain/providers/comments_provider.dart';
import 'package:los_pibbles_movies_app/domain/providers/favorites_provider.dart';
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
  String? get _userEmail => SessionManager.userEmail;
  String? get _memberSince => SessionManager.memberSince;

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {});
  }

  void _viewPhotoFullScreen() {
    final mediaUrl = _fotoPerfil;
    if (mediaUrl == null || mediaUrl.isEmpty) return;

    // 👇 Evaluamos si la URL termina en extensión de video
    final isVideo = mediaUrl.toLowerCase().endsWith('.mp4') || 
                    mediaUrl.toLowerCase().endsWith('.mov');

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Stack(
        children: [
          Center(
            // 👇 Usamos nuestro nuevo widget que sabe manejar tanto imagen como video
            child: FullScreenMediaWidget(url: mediaUrl, isVideo: isVideo),
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

  String _getProfileThumbnail(String? url) {
    if (url == null || url.isEmpty) return '';
    
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.endsWith('.mp4') || lowerUrl.endsWith('.mov') || lowerUrl.endsWith('.3gp')) {
      // Reemplaza la extensión del video (.mp4, .mov, etc.) por .jpg
      return url.replaceAll(RegExp(r'\.(mp4|mov|3gp)$', caseSensitive: false), '.jpg');
    }
    return url;
  }




  Future<void> _pickAndUploadPhoto() async {
    final XFile? picked = await _picker.pickMedia(
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final mediaFile = File(picked.path);
      final userId = SessionManager.userId!;

      final isVideo = picked.path.toLowerCase().endsWith('.mp4') || 
                      picked.path.toLowerCase().endsWith('.mov');

      // 💡 Recomendación: Modifica updatePhoto para que reciba el 'isVideo' si el backend lo necesita
      await ProfileService.updatePhoto(userId, mediaFile);
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
      context.read<FavoritesProvider>().clearLocalState();
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final favoritesCount = favoritesProvider.favoriteMovieIds.length;

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
              child: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColors.primary500,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      ProfileCardWidget(
                        userName: _userName ?? 'Usuario',
                        email: _userEmail ?? 'Sin correo registrado',
                        memberSince: formattedDate,
                        favoritesCount: favoritesCount.toString(),
                        isUploading: _isUploading,
                        fotoPerfil: _getProfileThumbnail(_fotoPerfil),
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
                          onTap: () async {
                            final success = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ChangeEmailDialog(),
                            );
                            if (success == true) setState(() {});
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
                          onTap: () async {
                            final success = await showDialog<bool>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ChangeNameDialog(),
                            );
                            if (success == true) setState(() {});
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

// =========================================================================
// 👇 NUEVO WIDGET: Maneja la visualización de Imagen estática o Video
// =========================================================================
class FullScreenMediaWidget extends StatefulWidget {
  final String url;
  final bool isVideo;

  const FullScreenMediaWidget({super.key, required this.url, required this.isVideo});

  @override
  State<FullScreenMediaWidget> createState() => _FullScreenMediaWidgetState();
}

class _FullScreenMediaWidgetState extends State<FullScreenMediaWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      // Si es video, inicializamos el controlador
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {});
          _controller!.setLooping(true); // Se repite infinitamente
          _controller!.play(); // Autoplay al abrir
        });
    }
  }

  @override
  void dispose() {
    // Es vital destruir el controlador al cerrar para no agotar la memoria
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVideo) {
      // Comportamiento normal para imágenes
      return InteractiveViewer(
        maxScale: 4,
        child: Image.network(widget.url, fit: BoxFit.contain),
      );
    }

    // Comportamiento para videos
    if (_controller != null && _controller!.value.isInitialized) {
      return InteractiveViewer(
        maxScale: 4,
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      );
    } else {
      // Mientras carga el video, mostramos un círculo de carga
      return const CircularProgressIndicator(color: AppColors.primary500);
    }
  }
}