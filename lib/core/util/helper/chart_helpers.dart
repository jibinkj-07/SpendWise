import 'dart:ui';

import '../../../features/budget/domain/model/category_model.dart';

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

class CategoryChartData {
  final CategoryModel category;
  final double amount;

  CategoryChartData({
    required this.category,
    required this.amount,
  });
}
