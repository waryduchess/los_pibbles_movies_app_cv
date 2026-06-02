import 'package:flutter/material.dart';

import '../../resources/color/colors.dart';
import '../../resources/styles/styles.dart';

class InputWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;

  const InputWidget({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.label.copyWith(
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: AppStyles.body.copyWith(
            color: AppColors.white,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.body.copyWith(
              color: AppColors.secondary400,
            ),
            filled: true,
            fillColor: AppColors.secondary1000,
            errorText: errorText,
            errorStyle: AppStyles.bodySm.copyWith(
              color: AppColors.error,
            ),
            suffixIcon: hasError
                ? const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.secondary700,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.accent500,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}