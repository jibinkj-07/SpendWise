import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view_model/dashboard_helper.dart';

import '../../../../common/data/model/expense_model.dart';
import '../../../../common/widget/category_tile.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:54:24

class TopExpenses extends StatelessWidget {
  final List<ExpenseModel> expenseList;
  final ValueNotifier<MapEntry<DateTime, bool>> viewOption;

  const TopExpenses(
      {super.key, required this.expenseList, required this.viewOption});

  @override
  Widget build(BuildContext context) {
    if (expenseList.isEmpty) return const SizedBox.shrink();
    final category =
        DashboardHelper.getTopExpensiveCategory(expenseList, context);
    final month = DashboardHelper.getTopExpensiveMonth(expenseList);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: viewOption,
            builder: (ctx, view, child) {
              return view.value ? const SizedBox.shrink() : child!;
            },
            child: CategoryTile(
              color: Colors.deepOrange,
              title: const Text(
                "Top spending Month",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.0,
                ),
              ),
              subtitle: Text(
                month.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              trailing: Text(
                AppHelper.amountFormatter(month.value),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          CategoryTile(
            color: AppHelper.hexToColor(category.key.color),
            title: const Text(
              "Top spending category",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12.0,
              ),
            ),
            subtitle: Text(
              category.key.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            trailing: Text(
              AppHelper.amountFormatter(category.value),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
