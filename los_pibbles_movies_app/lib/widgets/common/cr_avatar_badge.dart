import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CrAvatarBadge extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const CrAvatarBadge({
    super.key,
    required this.imageUrl,
    this.radius = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.surface,
            backgroundImage: NetworkImage(imageUrl),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}