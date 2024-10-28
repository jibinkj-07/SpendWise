import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/expense_list_tile.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/month_chart_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../common/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 19:05:42

class ExpenseList extends StatefulWidget {
  final List<ExpenseModel> expenseList;
  final ExpenseFilter currentFilter;

  const ExpenseList({
    super.key,
    required this.expenseList,
    required this.currentFilter,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final List<ExpenseFilter> _filters = ExpenseFilter.values;
  late ValueNotifier<ExpenseFilter> _currentFilter;

  @override
  void initState() {
    _currentFilter = ValueNotifier(widget.currentFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupExpenseByDate(widget.expenseList);

    return groupedItems.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: MonthChartView(expenseList: widget.expenseList),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.22,
                            squeeze: 1.2,
                            useMagnifier: true,
                            itemExtent: 32.0,
                            scrollController: FixedExtentScrollController(
                              initialItem:
                                  _filters.indexOf(widget.currentFilter),
                            ),
                            onSelectedItemChanged: (int selectedItem) =>
                                _currentFilter.value =
                                    _filters.elementAt(selectedItem),
                            children: List<Widget>.generate(
                              _filters.length,
                              (int index) {
                                return Center(
                                  child: Text(
                                      "${_filters[index].name.substring(0, 1).toUpperCase()}${_filters[index].name.substring(1)}"),
                                );
                              },
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.filter_list_rounded),
                        label: Text(
                            "${widget.currentFilter.name.substring(0, 1).toUpperCase()}${widget.currentFilter.name.substring(1)}"),
                      ),
                    ],
                  ),
                ),
              ),
              for (final dateHeader in groupedItems.entries)
                Section(
                  title: DateFormat("dd MMMM, EEEE").format(dateHeader.key),
                  amount: AppHelper.amountFormatter(
                    _getTotal(dateHeader.value),
                  ),
                  items: List.generate(
                    dateHeader.value.length,
                    (index) => ExpenseListTile(
                      expense: dateHeader.value[index],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100.0)),
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

  double _getTotal(List<ExpenseModel> expenses) {
    double sum = 0.0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * .4,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: child),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        context.read<ExpenseBloc>().add(
                            UpdateFilter(expenseFilter: _currentFilter.value));
                        Navigator.pop(context);
                      },
                      child: const Text("Done"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends MultiSliver {
  Section({
    super.key,
    required String title,
    required String amount,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Material(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.05),
                    border: const Border(
                      bottom: BorderSide(
                        color: Colors.black26,
                        width: .2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
