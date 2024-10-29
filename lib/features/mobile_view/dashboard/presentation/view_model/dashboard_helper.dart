import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';

import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/data/model/category_model.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../goal/presentation/helper/goal_helper.dart';

sealed class DashboardHelper {
  static List<ChartData> getMonthWiseChartData(List<ExpenseModel> expenses) {
    List<ChartData> items = [];
    Map<DateTime, double> monthData = {};
    for (final item in expenses) {
      if (monthData.containsKey(item.date)) {
        monthData[item.date] = monthData[item.date]! + item.amount;
      } else {
        monthData[item.date] = item.amount;
      }
    }
    items = monthData.entries.map((entry) {
      return ChartData(DateFormat.MMMEd().format(entry.key), entry.value);
    }).toList();
    return items;
  }

  static List<ChartData> getUserWiseChartData(List<ExpenseModel> expenses) {
    List<ChartData> items = [];
    Map<String, double> userData = {};
    for (final item in expenses) {
      if (userData.containsKey(item.createdUser.uid)) {
        userData[item.createdUser.uid] =
            userData[item.createdUser.uid]! + item.amount;
      } else {
        userData[item.createdUser.uid] = item.amount;
      }
    }
    items = userData.entries.map((entry) {
      final item =
          expenses.firstWhere((item) => item.createdUser.uid == entry.key);

      return ChartData(
        item.createdUser.name,
        entry.value,
        GoalHelper.getColorForLetter(
          item.createdUser.name.substring(0, 1),
        ),
      );
    }).toList();
    return items;
  }

  static List<ChartData> getYearWiseFinanceData(
      {required List<ExpenseModel> list}) {
    // Create a map to store monthly totals
    Map<String, double> monthlyFinance = {
      'Jan': 0.0,
      'Feb': 0.0,
      'Mar': 0.0,
      'Apr': 0.0,
      'May': 0.0,
      'Jun': 0.0,
      'Jul': 0.0,
      'Aug': 0.0,
      'Sep': 0.0,
      'Oct': 0.0,
      'Nov': 0.0,
      'Dec': 0.0,
    };

    // Iterate through the expenses
    for (var expense in list) {
      // Check if the expense is in the desired year

      // Get the month abbreviation (e.g., Jan, Feb, Mar, etc.)
      String month = DateFormat('MMM').format(expense.date);

      // Add the expense amount to the corresponding month
      monthlyFinance[month] = monthlyFinance[month]! + expense.amount;
    }
    // Convert the map into a list of FinanceData
    List<ChartData> financeDataList = monthlyFinance.entries.map((entry) {
      return ChartData(entry.key, entry.value);
    }).toList();

    return financeDataList;
  }

  static Map<CategoryModel, double> getCategoryWiseTotalExpenseData(
    List<ExpenseModel> expenses,
    BuildContext context,
  ) {
    // Create a map to store the total expenses per category
    Map<String, double> categoryExpenses = {};

    // Iterate through the list of expenses
    for (var expense in expenses) {
      // Get the category
      // Add the expense amount to the corresponding category
      if (categoryExpenses.containsKey(expense.category.id)) {
        categoryExpenses[expense.category.id] =
            categoryExpenses[expense.category.id]! + expense.amount;
      } else {
        categoryExpenses[expense.category.id] = expense.amount;
      }
    }

    Map<CategoryModel, double> data = {};
    for (final item in categoryExpenses.entries) {
      try {
        final category = context
            .read<CategoryBloc>()
            .state
            .categoryList
            .firstWhere((i) => i.id == item.key);
        data[category] = item.value;
      } catch (e) {
        log("er $e");
      }
    }
    return data;
  }

  static MapEntry<CategoryModel, double> getTopExpensiveCategory(
    List<ExpenseModel> expenses,
    BuildContext context,
  ) {
    // Create a map to store the total expenses per category
    Map<String, double> categoryExpenses = {};

    // Iterate through the list of expenses
    for (var expense in expenses) {
      // Get the category
      // Add the expense amount to the corresponding category
      if (categoryExpenses.containsKey(expense.category.id)) {
        categoryExpenses[expense.category.id] =
            categoryExpenses[expense.category.id]! + expense.amount;
      } else {
        categoryExpenses[expense.category.id] = expense.amount;
      }
    }

    // Find the category with the maximum total expense
    String mostExpensiveCategoryId = "";
    double maxExpense = 0;

    for (final item in categoryExpenses.entries) {
      if (item.value > maxExpense) {
        maxExpense = item.value;
        mostExpensiveCategoryId = item.key;
      }
    }

    // Return both the most expensive category and the total expense
    CategoryModel? categoryModel;
    try {
      categoryModel = context
          .read<CategoryBloc>()
          .state
          .categoryList
          .firstWhere((item) => item.id == mostExpensiveCategoryId);
    } catch (e) {
      log("Er $e");
    }
    return MapEntry(
      categoryModel ?? CategoryModel.deleted(),
      maxExpense,
    );
  }

  static MapEntry<String, double> getTopExpensiveItem(
      List<ExpenseModel> expenses) {
    double sum = 0.0;
    String name = "";
    for (final item in expenses) {
      if (item.amount > sum) {
        name = item.title;
        sum = item.amount;
      }
    }
    return MapEntry(name, sum);
  }

  static MapEntry<String, double> getTopExpensiveMonthOrDay(
    List<ExpenseModel> expenses,
    bool isMonthView,
  ) {
    final yearData = isMonthView
        ? getMonthWiseChartData(expenses)
        : getYearWiseFinanceData(list: expenses);
    String monthOrDay = "";
    double maxExpense = 0;

    for (final item in yearData) {
      if (item.amount > maxExpense) {
        maxExpense = item.amount;
        monthOrDay = item.xValue;
      }
    }
    Map<String, String> months = {
      'jan': 'January',
      'feb': 'February',
      'mar': 'March',
      'apr': 'April',
      'may': 'May',
      'jun': 'June',
      'jul': 'July',
      'aug': 'August',
      'sep': 'September',
      'oct': 'October',
      'nov': 'November',
      'dec': 'December',
    };

    return MapEntry(
      isMonthView ? monthOrDay : months[monthOrDay.toLowerCase()] ?? "Unknown",
      maxExpense,
    );
  }

  static List<ChartData> getCategoryExpenseForYear(
    List<ExpenseModel> list,
    CategoryModel category,
  ) {
    // Create a map to store monthly totals
    Map<String, double> monthlyFinance = {
      'Jan': 0.0,
      'Feb': 0.0,
      'Mar': 0.0,
      'Apr': 0.0,
      'May': 0.0,
      'Jun': 0.0,
      'Jul': 0.0,
      'Aug': 0.0,
      'Sep': 0.0,
      'Oct': 0.0,
      'Nov': 0.0,
      'Dec': 0.0,
    };

    final filteredList =
        list.where((item) => item.category.id == category.id).toList();
    // Iterate through the expenses
    for (var expense in filteredList) {
      // Get the month abbreviation (e.g., Jan, Feb, Mar, etc.)
      String month = DateFormat('MMM').format(expense.date);

      // Add the expense amount to the corresponding month
      monthlyFinance[month] = monthlyFinance[month]! + expense.amount;
    }
    // Convert the map into a list of FinanceData
    List<ChartData> financeDataList = monthlyFinance.entries.map((entry) {
      return ChartData(
        entry.key,
        entry.value,
        AppHelper.hexToColor(category.color),
      );
    }).toList();

    return financeDataList;
  }

  static List<ChartData> getCategoryExpenseForMonth(
    List<ExpenseModel> list,
    CategoryModel category,
    DateTime monthDate,
  ) {
    List<ChartData> items = [];
    int lastDay = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    for (int day = 1; day <= lastDay; day++) {
      DateTime date = DateTime(monthDate.year, monthDate.month, day);

      final filteredList = list
          .where((item) =>
              item.date.year == date.year &&
              item.date.month == date.month &&
              item.date.day == date.day &&
              item.category.id == category.id)
          .toList();

      double totalAmount =
          filteredList.fold(0, (sum, item) => sum + item.amount);
      items.add(
        ChartData(
          DateFormat("dd").format(date),
          totalAmount,
          AppHelper.hexToColor(category.color),
        ),
      );
    }
    return items;
  }
}

class ChartData {
  final String xValue;
  final double amount;
  final Color? color;

  ChartData(this.xValue, this.amount, [this.color = Colors.blue]);
}
