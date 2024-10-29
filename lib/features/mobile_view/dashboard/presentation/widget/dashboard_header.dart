import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 18:45:51

class DashboardHeader extends StatefulWidget {
  final ValueNotifier<MapEntry<DateTime, bool>> viewOption;
  final ValueNotifier<List<ExpenseModel>> expenseList;

  const DashboardHeader({
    super.key,
    required this.viewOption,
    required this.expenseList,
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final ValueNotifier<bool> _isMonth = ValueNotifier(false);
  final int _kMinYear = 2023;
  List<int> _years = [];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.viewOption.value.key;
    _years = List<int>.generate(
      (DateTime.now().year - _kMinYear + 1),
      (index) => _kMinYear + index,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _isMonth.dispose();
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
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  );
                },
              ),
            ],
          ),
          FilledButton(
            onPressed: () {
              _showDialog(
                CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.2,
                  scrollController: FixedExtentScrollController(
                    initialItem: _years.indexOf(_selectedDate.year),
                  ),
                  onSelectedItemChanged: (int selectedItem) =>
                      _selectedDate = DateTime(_years.elementAt(selectedItem)),
                  children: List<Widget>.generate(
                    _years.length,
                    (int index) {
                      return SizedBox(
                        width: double.infinity,
                        child: Text(
                          _years[index].toString(),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: ValueListenableBuilder(
              valueListenable: widget.viewOption,
              builder: (ctx, viewOption, _) {
                return Text(
                  viewOption.value
                      ? DateFormat("MMM y").format(viewOption.key)
                      : "${viewOption.key.year}",
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
          child: ValueListenableBuilder(
            valueListenable: _isMonth,
            builder: (ctx, isMonth, _) {
              return Column(
                children: [
                  Expanded(child: isMonth ? _buildMonthPicker() : child),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _isMonth.value = !_isMonth.value,
                          child: Text(isMonth ? "Year" : "Month"),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            widget.viewOption.value = MapEntry(
                              _selectedDate,
                              _isMonth.value,
                            );
                            if (_isMonth.value) {
                              widget.expenseList.value = context
                                  .read<ExpenseBloc>()
                                  .state
                                  .expenseList
                                  .where(
                                    (item) => (item.date.year ==
                                            _selectedDate.year &&
                                        item.date.month == _selectedDate.month),
                                  )
                                  .toList();
                            } else {
                              widget.expenseList.value = context
                                  .read<ExpenseBloc>()
                                  .state
                                  .expenseList
                                  .where(
                                    (item) =>
                                        item.date.year == _selectedDate.year,
                                  )
                                  .toList();
                            }
                            Navigator.pop(context);
                          },
                          child: const Text("Done"),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return CupertinoDatePicker(
      itemExtent: 32.2,
      initialDateTime: _selectedDate,
      minimumDate: DateTime(_kMinYear),
      maximumDate: DateTime.now(),
      mode: CupertinoDatePickerMode.monthYear,
      onDateTimeChanged: (DateTime value) => _selectedDate = value,
    );
  }
}
