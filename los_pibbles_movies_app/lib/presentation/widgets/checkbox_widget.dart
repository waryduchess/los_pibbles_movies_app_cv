// widgets/checkbox_widget.dart
import 'package:flutter/material.dart';
import '../../resources/color/colors.dart';

class CheckboxWidget extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;

  const CheckboxWidget({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            checkColor: AppColors.white,
            activeColor: AppColors.accent600,
            side: const BorderSide(color: AppColors.accent600),
          ),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
