import 'package:my_budget/features/common/data/model/expense_model.dart';

import '../../common/presentation/bloc/expense_bloc.dart';

sealed class BlocHelper {
  static List<ExpenseModel> getSelectedMonthList(ExpenseState expenseState) {
    return expenseState.expenseList
        .where(
          (item) => (item.date.year == expenseState.selectedDate.year &&
              item.date.month == expenseState.selectedDate.month),
        )
        .toList();
  }
}
