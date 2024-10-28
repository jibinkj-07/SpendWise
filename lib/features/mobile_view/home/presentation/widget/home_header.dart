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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Expense"),
              const SizedBox(height: 10.0),
              Text(
                AppHelper.amountFormatter(_getTotal()),
                style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Month"),
              const SizedBox(height: 10.0),
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (ctx, state) {
                  return FilledButton.icon(
                    onPressed: () => _showDialog(CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: _kItemExtent,
                      scrollController: FixedExtentScrollController(
                        initialItem: _monthNames.indexOf(_selectedMonth.value),
                      ),
                      onSelectedItemChanged: (int selectedItem) =>
                          _selectedMonth.value =
                              _monthNames.elementAt(selectedItem),
                      children: List<Widget>.generate(
                        _monthNames.length,
                        (int index) {
                          return Center(child: Text(_monthNames[index]));
                        },
                      ),
                    )),
                    style: FilledButton.styleFrom(
                      foregroundColor: Colors.blue,
                      backgroundColor: Colors.blue.withOpacity(.15),
                    ),
                    icon: const Icon(Icons.date_range_rounded),
                    label: Text(
                      DateFormat.MMMM().format(state.selectedDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
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

  double _getTotal() {
    double sum = 0.0;
    for (final expense in widget.expenseList) {
      sum += expense.amount;
    }
    return sum;
  }
}
