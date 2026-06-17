import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class CrMessageCard extends StatelessWidget {
  final String message;
  final bool isError;

  const CrMessageCard({super.key, required this.message, this.isError = true});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isError ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: isError ? AppColors.error : AppColors.success),
        ),
        child: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, 
                 color: isError ? AppColors.error : AppColors.success),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(message, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}