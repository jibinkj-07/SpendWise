import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../transactions/domain/model/transaction_model.dart';

sealed class AnalysisHelper {
  static int getTotalWeeksInMonth(int year, int month) {
    // Get the total number of days in the month
    int daysInMonth = DateTime(year, month + 1, 0).day;

    // Use a Set to store unique week numbers
    Set<int> weekNumbers = {};

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(year, month, day);

      // Calculate the ISO week number
      int weekNumber = ((date.day - date.weekday + 10) ~/ 7);
      weekNumbers.add(weekNumber);
    }

    // Return the count of unique week numbers
    return weekNumbers.length;
  }

  static DateTime getStartOfWeek(int year, int month, int weekNumber) {
    // Start with the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Find the first Monday of the month
    DateTime firstMondayOfMonth = firstDayOfMonth;
    while (firstMondayOfMonth.weekday != DateTime.monday) {
      firstMondayOfMonth = firstMondayOfMonth.subtract(const Duration(days: 1));
    }

    // Calculate the first day of the desired week (weekNumber)
    int daysToAdd = (weekNumber - 1) * 7;
    DateTime startOfWeek = firstMondayOfMonth.add(Duration(days: daysToAdd));

    return startOfWeek;
  }

  static DateTime getEndOfWeek(int year, int month, int weekNumber) {
    DateTime startOfWeek = getStartOfWeek(year, month, weekNumber);

    // Add 6 days to get the end of the week (Sunday)
    return startOfWeek.add(const Duration(days: 6));
  }

  static int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date)); // Day of the year
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  static List<MapEntry<dynamic, double>> getSummary(
    List<TransactionModel> transactions,
  ) {
    double topItemPrice = 0.0;
    String topItemId = "";
    Map<DateTime, double> dayTrans = {};
    Map<DateTime, double> monthTrans = {};
    Map<String, double> catTrans = {};

    // Iterating through transactions once for summary calculations
    for (final trans in transactions) {
      // Track top item
      if (trans.amount > topItemPrice) {
        topItemPrice = trans.amount;
        topItemId = trans.id;
      }

      // Day, Month, Category
      final day = DateTime(trans.date.year, trans.date.month, trans.date.day);
      dayTrans[day] = (dayTrans[day] ?? 0.0) + trans.amount;

      final month = DateTime(trans.date.year, trans.date.month);
      monthTrans[month] = (monthTrans[month] ?? 0.0) + trans.amount;

      final category = trans.categoryId;
      catTrans[category] = (catTrans[category] ?? 0.0) + trans.amount;
    }

    // Get top item transaction directly by id lookup
    final item = transactions.firstWhere(
      (item) => item.id == topItemId,
      orElse: () => TransactionModel.dummy(),
    );

    final day = _findHighestByDateTime(dayTrans);
    final month = _findHighestByDateTime(monthTrans);
    final category = _findHighestByString(catTrans);
    return [
      MapEntry(day.key, day.value),
      MapEntry(month.key, month.value),
      MapEntry(category.key, category.value),
      MapEntry(item, topItemPrice),
    ];
  }

// Optimized to work directly with Map<DateTime, double> to avoid redundant iteration
  static MapEntry<DateTime, double> _findHighestByDateTime(
    Map<DateTime, double> data,
  ) {
    DateTime highestDate =
        data.isNotEmpty ? data.entries.first.key : DateTime.now();
    double highestAmount = data.isNotEmpty ? data.entries.first.value : 0.0;

    data.forEach((date, totalAmount) {
      if (totalAmount > highestAmount) {
        highestAmount = totalAmount;
        highestDate = date;
      }
    });

    return MapEntry(highestDate, highestAmount);
  }

// Optimized to work directly with Map<String, double> to avoid redundant iteration
  static MapEntry<String, double> _findHighestByString(
      Map<String, double> data) {
    String highestCategory = data.isNotEmpty ? data.entries.first.key : "";
    double highestAmount = data.isNotEmpty ? data.entries.first.value : 0.0;

    data.forEach((category, totalAmount) {
      if (totalAmount > highestAmount) {
        highestAmount = totalAmount;
        highestCategory = category;
      }
    });

    return MapEntry(highestCategory, highestAmount);
  }
}
