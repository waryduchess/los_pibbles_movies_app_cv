import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class ProfilePhotoWidget extends StatelessWidget {
  final bool isUploading;
  final String? fotoPerfil;
  final VoidCallback? onTap;
  final VoidCallback? onCameraTap;

  const ProfilePhotoWidget({
    super.key,
    required this.isUploading,
    this.fotoPerfil,
    this.onTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary500, width: 3),
            ),
            child: isUploading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary500,
                    ),
                  )
                : fotoPerfil != null && fotoPerfil!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          fotoPerfil!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultAvatar(),
                        ),
                      )
                    : _buildDefaultAvatar(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: isUploading ? null : onCameraTap,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary1000, width: 2),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondary800,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: AppColors.white, size: 32),
    );
  }
}
