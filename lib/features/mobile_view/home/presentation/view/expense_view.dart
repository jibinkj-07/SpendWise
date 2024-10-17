import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';

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
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Expense",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  AppHelper.amountFormatter(2345.00213),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
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
  }
}
