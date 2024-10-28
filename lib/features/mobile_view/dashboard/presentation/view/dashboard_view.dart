import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/category_charts.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/category_stacked_chart.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/dashboard_header.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/month_bar_chart.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/top_expenses.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/widget/user_chart.dart';
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
  // _viewOption hold selected date and monthView bool option
  final ValueNotifier<MapEntry<DateTime, bool>> _viewOption = ValueNotifier(
    MapEntry(DateTime.now(), false),
  );

  final ValueNotifier<List<ExpenseModel>> _expenseList = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _expenseList.value = context
        .read<ExpenseBloc>()
        .state
        .expenseList
        .where((item) => item.date.year == _viewOption.value.key.year)
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _expenseList.dispose();
    _viewOption.dispose();
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
                viewOption: _viewOption,
                expenseList: _expenseList,
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _expenseList,
                  builder: (ctx, expenses, _) {
                    return expenses.isNotEmpty
                        ? ListView(
                            children: [
                              TopExpenses(
                                expenseList: expenses,
                                viewOption: _viewOption,
                              ),

                              MonthBarChart(
                                viewOption: _viewOption,
                                expenseList: expenses,
                              ),
                              CategoryCharts(expenseList: expenses),
                              CategoryStackedLineChart(
                                expenseList: expenses,
                                viewOption: _viewOption,
                              ),
                              UserChart(expenseList: expenses),
                            ],
                          )
                        : const NoAccess(isEmpty: true);
                  },
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
