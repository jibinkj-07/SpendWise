import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/helper/chart_helpers.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../transactions/domain/model/transaction_model.dart';

sealed class AnalyticsChartHelper {
  static List<WeekWiseChartData> getWeekChartData({
    required DateTime startDate,
    required List<TransactionModel> transactions,
  }) {
    // Group transactions by their date
    Map<DateTime, double> transactionMap = {};
    for (var transaction in transactions) {
      final date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      transactionMap[date] = (transactionMap[date] ?? 0.0) + transaction.amount;
    }

    // Prepare the chart data for the week
    List<WeekWiseChartData> chartData = [];
    for (int i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      chartData.add(WeekWiseChartData(
        date: date,
        amount: transactionMap[date] ?? 0.0,
      ));
    }

    // Sort by date
    chartData.sort((a, b) => a.date.compareTo(b.date));

    return chartData;
  }

  static List<WeekWiseChartData> getMonthChartData({
    required DateTime month,
    required List<TransactionModel> transactions,
  }) {
    // Group transactions by their date
    Map<DateTime, double> transactionMap = {};
    for (var transaction in transactions) {
      final date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      transactionMap[date] = (transactionMap[date] ?? 0.0) + transaction.amount;
    }

    // Prepare the chart data for the week
    List<WeekWiseChartData> chartData = [];
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);
    for (DateTime date = startDate;
        date.isBefore(endDate.add(Duration(days: 1)));
        date = date.add(Duration(days: 1))) {
      chartData.add(WeekWiseChartData(
        date: date,
        amount: transactionMap[date] ?? 0.0,
      ));
    }

    // Sort by date
    chartData.sort((a, b) => a.date.compareTo(b.date));

    return chartData;
  }

  static List<WeekWiseChartData> getYearChartData({
    required DateTime year,
    required List<TransactionModel> transactions,
  }) {
    // Group transactions by their date
    Map<DateTime, double> transactionMap = {};
    for (var transaction in transactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, 1);
      transactionMap[date] = (transactionMap[date] ?? 0.0) + transaction.amount;
    }

    // Prepare the chart data for the week
    List<WeekWiseChartData> chartData = [];

    for (int month = 1; month <= 12; month++) {
      final monthKey = DateTime(year.year, month, 1);
      chartData.add(WeekWiseChartData(
        date: monthKey,
        amount: transactionMap[monthKey] ?? 0.0,
      ));
    }

    // Sort by date
    chartData.sort((a, b) => a.date.compareTo(b.date));

    return chartData;
  }

  static List<CategoryChartData> getCategoryChartData({
    required BuildContext context,
    required List<TransactionModel> transactions,
  }) {
    final categoryBloc =
        (context.read<CategoryViewBloc>().state as CategorySubscribed);
    // Group transactions by their date
    Map<String, double> transactionMap = {};
    for (var transaction in transactions) {
      transactionMap[transaction.categoryId] =
          (transactionMap[transaction.categoryId] ?? 0.0) + transaction.amount;
    }

    // Prepare the chart data for the week
    List<CategoryChartData> chartData = [];

    for (final category in categoryBloc.categories) {
      chartData.add(CategoryChartData(
        category: category,
        amount: transactionMap[category.id] ?? 0.0,
      ));
    }

    // Sort by date
    chartData.sort((a, b) => b.amount.compareTo(a.amount));

    return chartData;
  }
}
