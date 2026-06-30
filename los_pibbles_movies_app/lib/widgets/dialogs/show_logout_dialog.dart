import 'package:flutter/material.dart';
import 'package:los_pibbles_movies_app/widgets/dialogs/logout_dialog.dart';

void showLogoutDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return LogoutDialog(
        onConfirm: onConfirm,
      );
    },
  );
}