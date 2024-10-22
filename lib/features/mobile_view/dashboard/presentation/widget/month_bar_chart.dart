import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/data/model/expense_model.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:05:04

class MonthBarChart extends StatelessWidget {
  final ValueNotifier<int> selectedYear;
  final ValueNotifier<List<ExpenseModel>> expenseList;

  const MonthBarChart({
    super.key,
    required this.selectedYear,
    required this.expenseList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12, width: 1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ValueListenableBuilder(
        valueListenable: selectedYear,
        builder: (ctx, selectedYear, _) {
          return SfCartesianChart(
            plotAreaBorderWidth: 0,
            title: ChartTitle(
              text: 'Monthly Expense Chart for $selectedYear',
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
              ),
            ),
            primaryXAxis: const CategoryAxis(
              labelPlacement: LabelPlacement.onTicks,
              majorGridLines: MajorGridLines(color: Colors.transparent),
              labelStyle: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(color: Colors.transparent),
              minorGridLines: const MinorGridLines(color: Colors.transparent),
              numberFormat: NumberFormat.currency(
                symbol: '€',
                decimalDigits: 0,
              ),
              labelStyle: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            series: <CartesianSeries>[
              ColumnSeries<FinanceData, String>(
                dataSource: _getMonthlyFinanceData(selectedYear, context),
                xValueMapper: (FinanceData data, _) => data.month,
                yValueMapper: (FinanceData data, _) => data.amount,
                color: Colors.pink,
                dataLabelMapper: (FinanceData data, _) => data.amount > 0
                    ? AppHelper.amountFormatter(data.amount, 1)
                    : '',
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.0,
                  ),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Function to retrieve finance data for a specific year grouped by month
  List<FinanceData> _getMonthlyFinanceData(int year, BuildContext context) {
    // Create a map to store monthly totals
    Map<String, double> monthlyFinance = {
      'Jan': 0.0,
      'Feb': 0.0,
      'Mar': 0.0,
      'Apr': 0.0,
      'May': 0.0,
      'Jun': 0.0,
      'Jul': 0.0,
      'Aug': 0.0,
      'Sep': 0.0,
      'Oct': 0.0,
      'Nov': 0.0,
      'Dec': 0.0,
    };
    final expenses = context
        .read<ExpenseBloc>()
        .state
        .expenseList
        .where((item) => item.date.year == year)
        .toList();
    // Iterate through the expenses
    for (var expense in expenses) {
      // Check if the expense is in the desired year
      if (expense.date.year == year) {
        // Get the month abbreviation (e.g., Jan, Feb, Mar, etc.)
        String month = DateFormat('MMM').format(expense.date);

        // Add the expense amount to the corresponding month
        monthlyFinance[month] = monthlyFinance[month]! + expense.amount;
      }
    }
    // Convert the map into a list of FinanceData
    List<FinanceData> financeDataList = monthlyFinance.entries.map((entry) {
      return FinanceData(entry.key, entry.value);
    }).toList();

    return financeDataList;
  }
}

class FinanceData {
  FinanceData(this.month, this.amount);

  final String month;
  final double amount;
}
