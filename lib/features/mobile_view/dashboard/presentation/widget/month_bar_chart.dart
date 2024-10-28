import 'package:flutter/material.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view_model/dashboard_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/data/model/expense_model.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:05:04

class MonthBarChart extends StatelessWidget {
  final ValueNotifier<MapEntry<DateTime, bool>> viewOption;
  final List<ExpenseModel> expenseList;

  const MonthBarChart({
    super.key,
    required this.viewOption,
    required this.expenseList,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewOption,
      builder: (ctx, view, _) {
        // View is month only so dont need to show this chart
        if (view.value) {
          return const SizedBox.shrink();
        }
        return Container(
          height: MediaQuery.sizeOf(context).height * .3,
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 20.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 10.0,
          ),
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
            plotAreaBorderWidth: 0,
            title: ChartTitle(
              text: 'Monthly Expense Chart for ${view.key.year}',
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
              ),
            ),
            primaryXAxis: const CategoryAxis(
              labelPlacement: LabelPlacement.onTicks,
              majorGridLines: MajorGridLines(color: Colors.transparent),
              majorTickLines: MajorTickLines(width: 0.0),
              labelStyle: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            primaryYAxis: const NumericAxis(isVisible: false),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource:
                    DashboardHelper.getYearWiseFinanceData(list: expenseList),
                xValueMapper: (ChartData data, _) => data.xValue,
                yValueMapper: (ChartData data, _) => data.amount,
                color: Colors.pink,
                dataLabelMapper: (ChartData data, _) => data.amount > 0
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
          ),
        );
      },
    );
  }
}
