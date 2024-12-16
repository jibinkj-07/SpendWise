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
