import 'package:intl/intl.dart';

sealed class AppHelper {
  static String amountFormatter(double amount) => NumberFormat.currency(
        locale: 'en_IE',
        symbol: '€',
      ).format(amount);
}
