import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:14:56

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (ctx, expenseState) {
      if (expenseState.error != null) {
        expenseState.error!.showSnackBar(context);
      }
    }, builder: (ctx, expenseState) {
      if (expenseState.expenseStatus == ExpenseStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
      }

      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Expense",
                  ),
                  Text(
                    AppHelper.amountFormatter(2345.00213),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {},
                child: Text("Date"),
              ),
            ],
          ),
        ],
      );
    });
  }
}
