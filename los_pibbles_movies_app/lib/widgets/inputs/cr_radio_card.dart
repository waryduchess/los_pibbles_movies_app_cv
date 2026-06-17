import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class CrRadioCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CrRadioCard({super.key, required this.title, required this.description, required this.icon, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.10) : AppColors.surface,
            border: Border.all(color: isSelected ? color : AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: color.withOpacity(0.22), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(description, style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? color : AppColors.border, width: 2),
                ),
                child: isSelected ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color))) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}