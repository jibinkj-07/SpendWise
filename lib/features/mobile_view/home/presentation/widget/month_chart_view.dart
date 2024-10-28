import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/features/common/data/model/expense_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 21:07:05

class MonthChartView extends StatelessWidget {
  final List<ExpenseModel> expenseList;

  const MonthChartView({super.key, required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * .28,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SfCartesianChart(
        margin: const EdgeInsets.symmetric(horizontal: 0.0),
        plotAreaBorderWidth: 0,
        primaryXAxis: const CategoryAxis(
          title: AxisTitle(
            text: "Date",
            textStyle: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          ),
          labelStyle: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
          majorTickLines: MajorTickLines(width: 0.0),
          majorGridLines: MajorGridLines(color: Colors.transparent),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
          plotOffsetStart: 5,
        ),
        series: <CartesianSeries>[
          SplineAreaSeries<ChartData, String>(
            dataSource: _getChart(),
            xValueMapper: (ChartData data, _) => data.day,
            yValueMapper: (ChartData data, _) => data.expense,
            borderColor: Colors.blue,
            borderWidth: 2.0,
            splineType: SplineType.cardinal,
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.blue.shade50,
              ],
              stops: const [.1, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> _getChart() {
    List<ChartData> items = [];
    final currentDate = DateTime.now();
    int year = expenseList.first.date.year; // Specify the year
    int month = expenseList.first.date.month;
    int lastDay = DateTime(year, month + 1, 0).day;
    for (int day = 1; day <= lastDay; day++) {
      DateTime date = DateTime(year, month, day);
      final expenses = expenseList
          .where((item) =>
              item.date.year == date.year &&
              item.date.month == date.month &&
              item.date.day == date.day)
          .toList();

      // Assuming each item has an `amount` property
      double totalAmount = expenses.fold(0, (sum, item) => sum + item.amount);
      items.add(
        ChartData(
            DateFormat("dd").format(date),
            (date.month == currentDate.month && date.day > currentDate.day)
                ? null
                : totalAmount),
      ); // Add total amount to ChartData
    }

    return items;
  }
}

class ChartData {
  ChartData(this.day, this.expense);

  final String day;
  final double? expense;
}
