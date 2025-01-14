import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/widget/custom_loading.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analysis_helper.dart';
import '../helper/analytics_chart_helper.dart';
import 'category_chart.dart';
import 'summary.dart';
import 'transaction_chart.dart';
import 'user_spending_chart.dart';

/// @author : Jibin K John
/// @date   : 07/01/2025
/// @time   : 19:54:35

class Dashboard extends StatefulWidget {
  final AnalysisState analysisState;
  final Size size;
  final VoidCallback fetchData;

  const Dashboard({
    super.key,
    required this.analysisState,
    required this.size,
    required this.fetchData,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ValueNotifier<bool> _viewAllCategory = ValueNotifier(false);

  @override
  void dispose() {
    _viewAllCategory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.analysisState.error != null) {
      return Padding(
        padding: EdgeInsets.all(AppHelper.horizontalPadding(widget.size)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.analysisState.error!.message,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            FilledButton(onPressed: widget.fetchData, child: Text("Try again"))
          ],
        ),
      );
    }

    if (widget.analysisState.status == AnalysisStatus.loading) {
      return CustomLoading();
    }

    final total = TransactionHelper.findTotal(
      widget.analysisState.transactions,
    );
    return BlocBuilder<CategoryViewBloc, CategoryViewState>(
      builder: (ctx, cateState) {
        if (cateState is CategorySubscribing) {
          return CustomLoading();
        }
        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppHelper.horizontalPadding(widget.size),
            vertical: 10.0,
          ),
          children: [
            Summary(
              analysisState: widget.analysisState,
              summary: AnalysisHelper.getSummary(
                widget.analysisState.transactions,
              ),
              total: total,
            ),
            TransactionChart(
              chartData: _getTransactionChartData(),
              analysisState: widget.analysisState,
              size: widget.size,
            ),
            CategoryChart(
              analysisState: widget.analysisState,
              viewAllCategory: _viewAllCategory,
              chartData: AnalyticsChartHelper.getCategoryChartData(
                context: context,
                transactions: widget.analysisState.transactions,
              ),
              total: total,
            ),
            UserSpendingChart(
              analysisState: widget.analysisState,
              total: total,
              chartData: AnalyticsChartHelper.getMembersSpendingChartData(
                transactions: widget.analysisState.transactions,
                budgetMembers: widget.analysisState.budgetMembers,
              ),
            ),
          ],
        );
      },
    );
  }

  List<WeekWiseChartData> _getTransactionChartData() {
    if (widget.analysisState.filter == AnalyticsFilter.week) {
      return AnalyticsChartHelper.getWeekChartData(
        transactions: widget.analysisState.transactions,
        startDate: AnalysisHelper.getStartOfWeek(
          widget.analysisState.date.year,
          widget.analysisState.date.month,
          widget.analysisState.weekNumber,
        ),
      );
    } else if (widget.analysisState.filter == AnalyticsFilter.month) {
      return AnalyticsChartHelper.getMonthChartData(
        transactions: widget.analysisState.transactions,
        month: widget.analysisState.date,
      );
    } else {
      return AnalyticsChartHelper.getYearChartData(
        transactions: widget.analysisState.transactions,
        year: widget.analysisState.date,
      );
    }
  }
}
