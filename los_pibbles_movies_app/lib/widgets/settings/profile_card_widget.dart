import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';
import 'profile_photo_widget.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userName;
  final String email;
  final String memberSince;
  final String favoritesCount;
  final bool isUploading;
  final String? fotoPerfil;
  final VoidCallback? onPhotoTap;
  final VoidCallback? onCameraTap;

  const ProfileCardWidget({
    super.key,
    required this.userName,
    required this.email,
    required this.memberSince,
    required this.favoritesCount,
    required this.isUploading,
    this.fotoPerfil,
    this.onPhotoTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary800,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ProfilePhotoWidget(
                isUploading: isUploading,
                fotoPerfil: fotoPerfil,
                onTap: onPhotoTap,
                onCameraTap: onCameraTap,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      memberSince,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondary1000,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: AppColors.error, size: 18),
                const SizedBox(width: 6),
                Text(
                  favoritesCount,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'películas favoritas',
                  style: TextStyle(color: AppColors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
