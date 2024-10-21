import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/expense_list_tile.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/month_chart_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 19:05:42

class ExpenseList extends StatelessWidget {
  final List<ExpenseModel> expenseList;

  const ExpenseList({
    super.key,
    required this.expenseList,
  });

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupExpenseByDate(expenseList);
    var sortedMap = Map.fromEntries(
      groupedItems.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );

    return sortedMap.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MonthChartView(expenseList: expenseList),
              ),
              for (final dateHeader in sortedMap.entries)
                Section(
                  title: DateFormat("dd MMMM, EEEE").format(dateHeader.key),
                  items: List.generate(
                    dateHeader.value.length,
                    (index) => ExpenseListTile(
                      expense: dateHeader.value[index],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 100.0,
                ),
              ),
            ],
          )
        : const Center(
            child: Text(
              "No Expense added",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
  }

  Map<DateTime, List<ExpenseModel>> _groupExpenseByDate(
    List<ExpenseModel> expenses,
  ) {
    Map<DateTime, List<ExpenseModel>> items = {};

    for (final expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (items.containsKey(date)) {
        items[date]!.add(expense);
      } else {
        items[date] = [expense];
      }
    }
    return items;
  }
}

class Section extends MultiSliver {
  Section({
    super.key,
    required String title,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Material(
                child: Container(
                  color: Colors.blue.withOpacity(.05),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 5.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}
