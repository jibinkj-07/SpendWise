import 'package:flutter/material.dart';

import '../../config/app_config.dart';

class CustomSnackBar {
  static void showErrorSnackBar(BuildContext context, String message) => _snackbar(
        context: context,
        bgColor: AppConfig.errorColor,
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
        bgColor: Colors.amber.shade100,
        textColor: Colors.black,
        message: message,
        icon: const Icon(
          Icons.info_rounded,
          size: 20.0,
          color: Colors.black,
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
        margin: const EdgeInsets.all(10.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
