import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/data/model/expense_model.dart';
import '../view_model/dashboard_helper.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 20:55:29

class CategoryCharts extends StatelessWidget {
  final List<ExpenseModel> expenseList;

  const CategoryCharts({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = DashboardHelper.getCategoryWiseTotalExpenseData(
      expenseList,
      context,
    )
        .entries
        .map(
          (entry) => ChartData(
            entry.key.title,
            entry.value,
            AppHelper.hexToColor(entry.key.color),
          ),
        )
        .toList();
    // Sort the list based on the amount
    chartData.sort((a, b) => a.amount.compareTo(b.amount));
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: SfCircularChart(
        title: const ChartTitle(
          text: 'Expenses by Category',
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
            explodeIndex: 0, // Emphasizes the first slice for visual effect
            radius: '90%',
          ),
        ],
      ),
    );
  }
}
