import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

enum CrButtonVariant { primary, secondary }

class CrButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final CrButtonVariant variant;

  // ✅ Constructor por defecto que redirige a 'primary' para que tus otras pantallas no rompan
  const CrButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  }) : variant = CrButtonVariant.primary;

  // ✅ Se agregó la coma corregida después de 'this.onPressed'
  const CrButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  }) : variant = CrButtonVariant.primary;

  const CrButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
  }) : variant = CrButtonVariant.secondary;

  @override
  State<CrButton> createState() => _CrButtonState();
}







class _CrButtonState extends State<CrButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isInactive = widget.isDisabled || widget.isLoading || widget.onPressed == null;
    
    return GestureDetector(
      onTapDown: isInactive ? null : (_) => setState(() => _scale = 0.98),
      onTapUp: isInactive ? null : (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: isInactive ? null : widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Opacity(
          opacity: isInactive ? 0.6 : 1.0,
          child: Container(
            height: 52,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.variant == CrButtonVariant.primary ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: widget.variant == CrButtonVariant.secondary ? Border.all(color: AppColors.border) : null,
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20, width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[Icon(widget.icon, size: 20), const SizedBox(width: AppSpacing.sm)],
                      Text(widget.label, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}