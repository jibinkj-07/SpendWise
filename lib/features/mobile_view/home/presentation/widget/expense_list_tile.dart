import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/expense_detail_modal_sheet.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 19:56:51

class ExpenseListTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseListTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppHelper.hexToColor(expense.category.color);
    bool isDark = bgColor.computeLuminance() < 0.5;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) =>
                ExpenseDetailModalSheet(expenseModel: expense),
          );
        },
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Text(
            expense.title.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: expense.description.isNotEmpty
            ? Text(
                expense.description,
                style: const TextStyle(
                  fontSize: 13.0,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Text(
          AppHelper.amountFormatter(expense.amount),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
