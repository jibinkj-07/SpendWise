import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 18:08:13

class HomeHeader extends StatefulWidget {
  final List<ExpenseModel> expenseList;
  final DateTime selectedDate;

  const HomeHeader({
    super.key,
    required this.expenseList,
    required this.selectedDate,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final double _kItemExtent = 32.0;
  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final ValueNotifier<String> _selectedMonth = ValueNotifier("");

  @override
  void initState() {
    _selectedMonth.value = _monthNames.elementAt(widget.selectedDate.month - 1);
    super.initState();
  }

  @override
  void dispose() {
    _selectedMonth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Total Expense"),
              Text(
                AppHelper.amountFormatter(_getTotal()),
                style: const TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (ctx, state) {
              return FilledButton.icon(
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: _kItemExtent,
                    scrollController: FixedExtentScrollController(
                      initialItem: _monthNames.indexOf(_selectedMonth.value),
                    ),
                    onSelectedItemChanged: (int selectedItem) => _selectedMonth
                        .value = _monthNames.elementAt(selectedItem),
                    children: List<Widget>.generate(
                      _monthNames.length,
                      (int index) {
                        return Center(child: Text(_monthNames[index]));
                      },
                    ),
                  ),
                  context,
                ),
                style: FilledButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.blue.withOpacity(.15),
                ),
                icon: const Icon(Icons.date_range_rounded),
                label: Text(
                  DateFormat.MMMM().format(state.selectedDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              );
            },
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
                  final userBloc = context.read<AuthBloc>().state;
                  context.read<ExpenseBloc>().add(UpdateDate(
                      date: DateTime(
                        widget.selectedDate.year,
                        _monthNames.indexOf(_selectedMonth.value) + 1,
                      ),
                      adminId: userBloc.userInfo?.adminId ?? ""));
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

  double _getTotal() {
    double sum = 0.0;
    for (final expense in widget.expenseList) {
      sum += expense.amount;
    }
    return sum;
  }
}
