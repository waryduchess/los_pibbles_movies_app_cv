import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CrTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction; // 1. Declaramos la propiedad

  const CrTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.textInputAction, // 2. La añadimos al constructor como opcional
  });

  @override
  State<CrTextField> createState() => _CrTextFieldState();
}

class _CrTextFieldState extends State<CrTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
      if (!_focusNode.hasFocus && widget.validator != null) {
        setState(() => _errorText = widget.validator!(widget.controller?.text));
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _errorText != null 
                  ? AppColors.error 
                  : (_isFocused ? AppColors.primary : AppColors.border),
              width: _isFocused ? 2 : 1,
            ),
            boxShadow: _isFocused ? [BoxShadow(color: AppColors.focusRing, blurRadius: 4)] : [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction, // 3. Se la asignamos al TextFormField nativo
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.textSecondary) : null,
              suffixIcon: widget.obscureText 
                  ? IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(_errorText!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
          ),
      ],
    );
  }
}