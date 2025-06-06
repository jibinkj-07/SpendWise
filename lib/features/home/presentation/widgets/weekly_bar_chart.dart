import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../helper/home_helper.dart';

class WeeklyBarChart extends StatefulWidget {
  final List<WeeklyChartData> chartData;
  final Size size;

  const WeeklyBarChart({
    super.key,
    required this.chartData,
    required this.size,
  });

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    canShowMarker: false,
    textStyle: TextStyle(
      fontFamily: AppConfig.fontFamily,
      fontWeight: FontWeight.w500,
    ),
    color: AppConfig.primaryColor,
    builder: (data, _, __, ___, ____) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        data.amount.toStringAsFixed(2),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontFamily: AppConfig.fontFamily,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    // Find the maximum amount in the current data
    double maxAmount = widget.chartData.map((data) => data.amount).reduce(
          (value, element) => value > element ? value : element,
        );
    maxAmount = maxAmount == 0 ? 50 : maxAmount;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .23,
      child: SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        margin: EdgeInsets.zero,
        plotAreaBackgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        borderWidth: 0,
        plotAreaBorderWidth: 0,
        enableSideBySideSeriesPlacement: false,
        primaryXAxis: CategoryAxis(
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            // Check if the label corresponds to today
            String today = formatChartDate(DateTime.now());
            return ChartAxisLabel(
              details.text,
              TextStyle(
                fontFamily: AppConfig.fontFamily,
                fontWeight:
                    details.text == today ? FontWeight.w900 : FontWeight.w500,
                fontSize: 11.0,
                color: details.text == today ? AppConfig.focusColor : null,
              ),
            );
          },
          majorGridLines: MajorGridLines(color: Colors.transparent),
          majorTickLines: MajorTickLines(width: 0.0),
          isVisible: true,
          axisLine: AxisLine(width: 0.0),
        ),
        primaryYAxis: NumericAxis(
          isVisible: true,
          maximum: maxAmount,
          numberFormat: NumberFormat.compactCurrency(
            decimalDigits: 0,
            symbol: (context.read<BudgetViewBloc>().state as BudgetSubscribed)
                .budget
                .currencySymbol,
          ),
          majorGridLines: MajorGridLines(
            dashArray: [6],
            width: .5,
          ),
          labelStyle: TextStyle(
            fontFamily: AppConfig.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 11.0,
          ),
          majorTickLines: MajorTickLines(width: 0.0),
          axisLine: AxisLine(width: 0.0),
        ),
        series: <CartesianSeries>[
          ColumnSeries<WeeklyChartData, String>(
            dataSource: widget.chartData,
            width: 0.4,
            pointColorMapper: (data, _) => data.isToday
                ? data.color.withValues(alpha: .2)
                : data.color.withValues(alpha: .08),
            xValueMapper: (data, _) => data.day,
            yValueMapper: (data, _) => maxAmount,
          ),
          ColumnSeries<WeeklyChartData, String>(
            dataSource: widget.chartData,
            width: 0.4,
            pointColorMapper: (data, _) => data.color,
            xValueMapper: (data, _) => data.day,
            yValueMapper: (data, _) => data.amount,
          )
        ],
      ),
    );
  }
}
