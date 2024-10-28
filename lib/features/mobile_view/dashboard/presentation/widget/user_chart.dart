import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/util/helper/app_helper.dart';
import '../../../../common/data/model/expense_model.dart';
import '../view_model/dashboard_helper.dart';

/// @author : Jibin K John
/// @date   : 28/10/2024
/// @time   : 18:26:30

class UserChart extends StatelessWidget {
  final List<ExpenseModel> expenseList;

  const UserChart({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData =
        DashboardHelper.getUserWiseChartData(expenseList);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: SfCircularChart(
        title: const ChartTitle(
          text: 'Expenses by user',
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
          ),
        ),
        legend: const Legend(
          position: LegendPosition.top,
          overflowMode: LegendItemOverflowMode.wrap,
          isVisible: true,
          textStyle: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.xValue,
            yValueMapper: (ChartData data, _) => data.amount,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelMapper: (ChartData data, _) =>
                AppHelper.amountFormatter(data.amount, 1),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
              ),
            ),
            explode: true,
            explodeIndex: 0,
            // Emphasizes the first slice for visual effect
            radius: '90%',
          ),
        ],
      ),
    );
  }
}
