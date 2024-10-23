import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/features/common/presentation/bloc/category_bloc.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view_model/dashboard_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/data/model/category_model.dart';
import '../../../../common/data/model/expense_model.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 19:05:04

class CategoryStackedLineChart extends StatelessWidget {
  final List<ExpenseModel> expenseList;
  final ValueNotifier<MapEntry<DateTime, bool>> viewOption;

  const CategoryStackedLineChart({
    super.key,
    required this.expenseList,
    required this.viewOption,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (ctx, state) {
      return ValueListenableBuilder(
          valueListenable: viewOption,
          builder: (ctx, view, _) {
            List<List<ChartData>> chartData = _getChartData(
              state.categoryList,
              view.value,
              view.key,
            );

            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12, width: 1),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: const ChartTitle(
                  text: 'Category Trends Over a Year',
                  textStyle: TextStyle(
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
                primaryYAxis: NumericAxis(
                  majorGridLines:
                      const MajorGridLines(color: Colors.transparent),
                  minorGridLines:
                      const MinorGridLines(color: Colors.transparent),
                  majorTickLines: const MajorTickLines(width: 0.0),
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
                  for (final data in chartData)
                    SplineSeries<ChartData, String>(
                      dataSource: data,
                      pointColorMapper: (ChartData data, _) => data.color,
                      xValueMapper: (ChartData data, _) => data.xValue,
                      yValueMapper: (ChartData data, _) => data.amount,
                    ),
                ],
              ),
            );
          });
    });
  }

  List<List<ChartData>> _getChartData(
      List<CategoryModel> categoryList, bool isMonth,
      [DateTime? date]) {
    List<List<ChartData>> chartData = [];
    for (final category in categoryList) {
      chartData.add(
        isMonth
            ? DashboardHelper.getCategoryExpenseForMonth(
                expenseList,
                category,
                date!,
              )
            : DashboardHelper.getCategoryExpenseForYear(expenseList, category),
      );
    }
    return chartData;
  }
}
