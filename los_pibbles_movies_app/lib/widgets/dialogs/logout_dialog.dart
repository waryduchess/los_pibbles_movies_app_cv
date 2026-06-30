import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/resources/color/colors.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.secondary1000,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: AppColors.secondary700.withOpacity(0.8),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 34,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              '¿Cerrar sesión?',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Tendrás que volver a iniciar sesión para acceder a tu cuenta y tus favoritos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            Divider(
              height: 1,
              color: AppColors.secondary700.withOpacity(0.8),
            ),

            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  VerticalDivider(
                    width: 1,
                    color: AppColors.secondary700.withOpacity(0.8),
                  ),

                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirm();
                      },
                      child: const Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}