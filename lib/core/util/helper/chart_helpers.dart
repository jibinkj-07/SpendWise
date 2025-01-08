import 'dart:ui';

class WeeklyChartData {
  final String day;
  final double amount;
  final bool isToday;
  final Color color;

  WeeklyChartData(
    this.day,
    this.amount,
    this.color,
    this.isToday,
  );
}

class WeekWiseChartData {
  final DateTime date;
  final double amount;

  WeekWiseChartData({
    required this.date,
    required this.amount,
  });
}
