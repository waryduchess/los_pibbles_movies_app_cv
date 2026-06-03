// widgets/back_button_widget.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../resources/color/colors.dart';


class BackButtonWidget extends StatelessWidget {
  final String route;

  const BackButtonWidget({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () => context.go(route),
    );
  }
}