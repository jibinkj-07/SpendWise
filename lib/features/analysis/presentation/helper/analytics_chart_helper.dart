import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/constant/constants.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../account/domain/model/user.dart';
import '../../../budget/domain/model/category_model.dart';
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

    // Convert budget members to a map for quick lookup
    final transactionMap = {
      for (var category in categoryBloc.categories) category.id: 0.0
    };
    final categoryLookup = {
      for (var category in categoryBloc.categories) category.id: category
    };

    for (var transaction in transactions) {
      transactionMap.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    // Convert to chart data
    final chartData = transactionMap.entries.map((entry) {
      final CategoryModel category =
          categoryLookup[entry.key] ?? CategoryModel.deleted(entry.key);
      return CategoryChartData(
        category: category,
        amount: transactionMap[category.id] ?? 0.0,
      );
    }).toList();

    // Sort by date
    chartData.sort((a, b) => b.amount.compareTo(a.amount));

    return chartData;
  }

  static List<MembersChartData> getMembersSpendingChartData({
    required List<TransactionModel> transactions,
    required List<User> budgetMembers,
  }) {
    // Convert budget members to a map for quick lookup
    final membersMap = {for (var member in budgetMembers) member.uid: 0.0};
    final userLookup = {for (var member in budgetMembers) member.uid: member};

    // Accumulate transaction amounts
    for (var transaction in transactions) {
      membersMap.update(
        transaction.createdUserId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    // Convert to chart data
    final chartData = membersMap.entries.map((entry) {
      final member = userLookup[entry.key] ?? User.deleted(entry.key);
      return MembersChartData(
        user: member,
        color: member.name == kDeletedUser
            ? Colors.black
            : AppHelper.getColorForLetter(member.name.substring(0, 1)),
        // Consider adding a color generator for variety
        amount: entry.value,
      );
    }).toList();

    // Sort by amount
    chartData.sort((a, b) => b.amount.compareTo(a.amount));

    return chartData;
  }
}
