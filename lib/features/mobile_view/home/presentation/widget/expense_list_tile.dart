import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/expense_detail_modal_sheet.dart';

import '../../../../common/data/model/category_model.dart';
import '../../../../common/presentation/bloc/category_bloc.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 19:56:51

class ExpenseListTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseListTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: BlocBuilder<CategoryBloc, CategoryState>(builder: (ctx, state) {
        final category = state.categoryList.firstWhere(
          (item) => item.id == expense.category.id,
          orElse: () => CategoryModel.deleted(),
        );

        Color bgColor = AppHelper.hexToColor(category.color);
        bool isDark = bgColor.computeLuminance() < 0.5;
        return ListTile(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => ExpenseDetailModalSheet(
                expenseModel: expense,
                category: category,
              ),
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
          subtitle: Text(
            category.title,
            style: const TextStyle(
              fontSize: 11.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            AppHelper.amountFormatter(expense.amount),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }),
    );
  }
}
