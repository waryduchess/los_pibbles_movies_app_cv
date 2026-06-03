import 'package:flutter/material.dart';
import '../../resources/color/colors.dart';
import '../../resources/styles/styles.dart';

class InputWidget extends StatefulWidget { 
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
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  Widget? _buildSuffixIcon() {
    if (widget.errorText != null) {
      return const Icon(Icons.error_outline, color: AppColors.error);
    }
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.secondary400,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.label.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,  
          style: AppStyles.body.copyWith(color: AppColors.white),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppStyles.body.copyWith(color: AppColors.secondary400),
            filled: true,
            fillColor: AppColors.secondary1000,
            errorText: widget.errorText,
            errorStyle: AppStyles.bodySm.copyWith(color: AppColors.error),
            suffixIcon: _buildSuffixIcon(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.secondary700),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.accent500, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}