import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../../common/widget/category_tile.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:54:24

class MostExpenseCategory extends StatelessWidget {
  final ValueNotifier<List<ExpenseModel>> expenseList;

  const MostExpenseCategory({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: ValueListenableBuilder(
        valueListenable: expenseList,
        builder: (ctx, expenses, _) {
          if (expenses.isEmpty) return const SizedBox.shrink();
          var mostExpensiveCategory =
              findMostExpensiveCategoryWithAmount(expenses, context);
          return CategoryTile(
            color: AppHelper.hexToColor(mostExpensiveCategory.key.color),
            title: const Text(
              "Top spending category",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.0,
              ),
            ),
            subtitle: Text(
              mostExpensiveCategory.key.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            trailing: Text(
              AppHelper.amountFormatter(mostExpensiveCategory.value),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          );
        },
      ),
    );
  }

// Function to find the most expensive category and its total amount
  MapEntry<CategoryModel, double> findMostExpensiveCategoryWithAmount(
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
    return MapEntry(
      context
          .read<CategoryBloc>()
          .state
          .categoryList
          .firstWhere((item) => item.id == mostExpensiveCategoryId),
      maxExpense,
    );
  }
}
