import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import '../../theme/app_colors.dart';

class CrSearchField extends StatefulWidget {
  final String placeholder;
  final ValueChanged<String> onChanged;

  const CrSearchField({super.key, required this.placeholder, required this.onChanged});

  @override
  State<CrSearchField> createState() => _CrSearchFieldState();
}

class _CrSearchFieldState extends State<CrSearchField> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () => widget.onChanged(query));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Campo de búsqueda',
      child: TextField(
        onChanged: _onSearchChanged,
        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}