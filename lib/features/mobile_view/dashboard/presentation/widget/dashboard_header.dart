import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 18:45:51

class DashboardHeader extends StatefulWidget {
  final ValueNotifier<int> selectedYear;
  final ValueNotifier<List<ExpenseModel>> expenseList;

  const DashboardHeader({
    super.key,
    required this.selectedYear,
    required this.expenseList,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  List<int> _years = [];
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedYear.value;
    _years = List<int>.generate(
      (DateTime.now().year - 2023 + 1),
      (index) => 2023 + index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total"),
              ValueListenableBuilder(
                valueListenable: widget.expenseList,
                builder: (ctx, expenses, _) {
                  double sum = 0.0;
                  for (final expense in expenses) {
                    sum += expense.amount;
                  }
                  return Text(
                    AppHelper.amountFormatter(sum),
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: () => _showDialog(
              CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: 32.2,
                scrollController: FixedExtentScrollController(
                  initialItem: _years.indexOf(_selectedYear),
                ),
                onSelectedItemChanged: (int selectedItem) =>
                    _selectedYear = _years.elementAt(selectedItem),
                children: List<Widget>.generate(
                  _years.length,
                  (int index) {
                    return Center(child: Text(_years[index].toString()));
                  },
                ),
              ),
              context,
            ),
            style: FilledButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.date_range_rounded),
            label: ValueListenableBuilder(
              valueListenable: widget.selectedYear,
              builder: (ctx, selectedYear, _) {
                return Text(
                  "$selectedYear",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(Widget child, BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * .35,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(child: child),
              FilledButton(
                onPressed: () {
                  widget.selectedYear.value = _selectedYear;
                  widget.expenseList.value = context
                      .read<ExpenseBloc>()
                      .state
                      .expenseList
                      .where((item) => item.date.year == _selectedYear)
                      .toList();
                  Navigator.pop(context);
                },
                child: const Text("Done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
