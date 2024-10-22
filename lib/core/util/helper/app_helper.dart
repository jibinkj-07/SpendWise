import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../widgets/custom_snackbar.dart';

sealed class AppHelper {
  static String amountFormatter(double amount) => NumberFormat.currency(
        locale: 'en_IE',
        symbol: '€ ',
      ).format(amount);

  // Function to convert hex string to Color
  static Color hexToColor(String hex) {
    // Add 'FF' for opacity if it's a 6-character string
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Add 'FF' for full opacity
    }

    return Color(int.parse(hex, radix: 16));
  }

  static void sendAccessRequestEmail(BuildContext context) async {
    const String subject = 'SpendWise Access Request';
    final String body = "Dear Developer,"
        "\nI hope this message finds you well. I am interested in gaining access to ${AppConstants.kAppName} and would appreciate your assistance in providing me with the necessary steps or credentials."
        "\nThank you for your time and support. I look forward to hearing from you soon."
        "\n\nBest regards,";
    final Uri params = Uri(
      scheme: 'mailto',
      path: AppConstants.kAppSupportMail,
      query: 'subject=$subject&body=$body', // add subject and body here
    );
    try {
      if (await canLaunchUrl(params)) {
        await launchUrl(params);

        CustomSnackBar.showSuccessSnackBar(context, "Mail sent");
      } else {
        CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
    }
  }
}
