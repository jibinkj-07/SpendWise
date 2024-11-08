import 'package:flutter/material.dart';

import '../../config/app_config.dart';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) => _snackbar(
        context: context,
        bgColor: Colors.red,
        textColor: Colors.white,
        message: message,
        icon: const Icon(Icons.error_rounded, size: 20.0, color: Colors.white),
      );

  static void showSuccessSnackBar(BuildContext context, String message) => _snackbar(
        context: context,
        bgColor: Colors.green,
        textColor: Colors.white,
        message: message,
        icon: const Icon(Icons.check_circle_rounded, size: 20.0, color: Colors.white),
      );

  static void showInfoSnackBar(
    BuildContext context,
    String message,
  ) =>
      _snackbar(
        context: context,
        bgColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).primaryColor,
        message: message,
        icon: const Icon(
          Icons.info_rounded,
          size: 20.0,
          color: Colors.amber,
        ),
      );

  static void _snackbar({
    required BuildContext context,
    required Color bgColor,
    required Color textColor,
    required String message,
    required Widget icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: bgColor,
        content: Row(
          children: [
            icon,
            const SizedBox(width: 5.0),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: AppConfig.fontFamily,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
