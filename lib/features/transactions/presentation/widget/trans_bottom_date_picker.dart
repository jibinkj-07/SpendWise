import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../bloc/transaction_bloc.dart';

sealed class TransBottomDatePicker {
  static void showDialog(BuildContext context) {
    final transactionBloc = context.read<TransactionBloc>().state;

    DateTime selectedDate = transactionBloc.date;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.sizeOf(context).height * .35,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate,
                  minimumDate: DateTime(2023),
                  maximumDate: DateTime(DateTime.now().year, 12),
                  mode: CupertinoDatePickerMode.monthYear,
                  onDateTimeChanged: (newDate) => selectedDate = newDate,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                    ),
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<TransactionBloc>().add(
                            UpdateTransactionDate(
                              date: selectedDate,
                              budgetId: (context.read<BudgetViewBloc>().state
                                      as BudgetSubscribed)
                                  .budget
                                  .id,
                            ),
                          );
                    },
                    child: Text("Done"),
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
