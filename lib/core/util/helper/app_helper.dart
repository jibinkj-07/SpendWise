import 'dart:ui';

import 'package:intl/intl.dart';

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
}
