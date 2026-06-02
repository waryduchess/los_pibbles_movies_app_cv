import 'package:flutter/material.dart';

import '../../resources/color/colors.dart';
import '../../resources/styles/styles.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.accent600;
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.accent500;
                  }
                  if (states.contains(WidgetState.focused)) {
                    return AppColors.accent700;
                  }
                  return AppColors.primary600;
                },
              ),
              foregroundColor: WidgetStateProperty.all(AppColors.white),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(text, style: AppStyles.button),
          ),
        );

      case ButtonType.secondary:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.accent600;
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return AppColors.accent500;
                  }
                  return AppColors.primary600;
                },
              ),
              side: WidgetStateProperty.resolveWith<BorderSide>(
                (states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const BorderSide(
                      color: AppColors.accent600,
                      width: 2,
                    );
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return const BorderSide(
                      color: AppColors.accent500,
                      width: 2,
                    );
                  }
                  return const BorderSide(
                    color: AppColors.primary600,
                    width: 2,
                  );
                },
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(text, style: AppStyles.button),
          ),
        );

      case ButtonType.tertiary:
        return TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.accent600;
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.accent500;
                }
                return AppColors.primary500;
              },
            ),
          ),
          child: Text(text, style: AppStyles.button),
        );
    }
  }
}