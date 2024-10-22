import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/dashboard_header.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/month_bar_chart.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/most_expense_category.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../util/widget/no_access.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:15:21

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ValueNotifier<int> _selectedYear = ValueNotifier(DateTime.now().year);
  final ValueNotifier<List<ExpenseModel>> _expenseList = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _expenseList.value = context
        .read<ExpenseBloc>()
        .state
        .expenseList
        .where((item) => item.date.year == _selectedYear.value)
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _expenseList.dispose();
    _selectedYear.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, authState) {
        if (authState.userInfo != null &&
            authState.userInfo!.adminId.isNotEmpty) {
          return Column(
            children: [
              DashboardHeader(
                selectedYear: _selectedYear,
                expenseList: _expenseList,
              ),
              Expanded(
                child: ListView(
                  children: [
                    MostExpenseCategory(expenseList: _expenseList),
                    MonthBarChart(
                      selectedYear: _selectedYear,
                      expenseList: _expenseList,
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const NoAccess();
      },
    );
  }
}
