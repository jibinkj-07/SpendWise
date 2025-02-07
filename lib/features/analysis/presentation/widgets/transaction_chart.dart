import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../bloc/analysis_bloc.dart';

/// @author : Jibin K John
/// @date   : 08/01/2025
/// @time   : 19:46:49

class TransactionChart extends StatelessWidget {
  final AnalysisState analysisState;
  final List<WeekWiseChartData> chartData;
  final Size size;

  const TransactionChart({
    super.key,
    required this.analysisState,
    required this.size,
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
          ),
        ],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transactions Chart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 20.0),
          _getChart(context),
        ],
      ),
    );
  }

  Widget _getChart(BuildContext context) {
    final TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      textStyle: TextStyle(
        fontFamily: AppConfig.fontFamily,
        fontWeight: FontWeight.w500,
      ),
      color: AppConfig.primaryColor,
      builder: (data, _, __, ___, ____) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatChartDate(data.date),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                fontFamily: AppConfig.fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              data.amount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.0,
                fontFamily: AppConfig.fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

// Find the maximum amount in the current data
    double maxAmount = chartData.isNotEmpty
        ? chartData.map((data) => data.amount).reduce(
              (value, element) => value > element ? value : element,
            )
        : 0.0;

    maxAmount = maxAmount == 0 ? 50 : maxAmount;
    return SizedBox(
      height: size.height * .23,
      child: SfCartesianChart(
        // zoomPanBehavior: ZoomPanBehavior(
        //   enablePinching: true,
        //   enablePanning: true,
        //   maximumZoomLevel: .5,
        //   zoomMode: ZoomMode.xy,
        // ),
        tooltipBehavior: tooltipBehavior,
        margin: EdgeInsets.zero,
        plotAreaBackgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        borderWidth: 0,
        plotAreaBorderWidth: 0,
        enableSideBySideSeriesPlacement: false,
        primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(color: Colors.transparent),
          majorTickLines: MajorTickLines(width: 0.0),
          isVisible: true,
          axisLine: AxisLine(width: 0.0),
          labelStyle: TextStyle(
            fontFamily: AppConfig.fontFamily,
            fontWeight: FontWeight.w500,
            fontSize: 10.0,
          ),
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
            fontSize: 10.0,
          ),
          majorTickLines: MajorTickLines(width: 0.0),
          axisLine: AxisLine(width: 0.0),
        ),
        series: <CartesianSeries>[
          ColumnSeries<WeekWiseChartData, String>(
            dataSource: chartData,
            borderRadius: BorderRadius.circular(20.0),
            width: 0.4,
            color: Colors.grey.shade100,
            xValueMapper: (data, _) => formatChartDate(data.date),
            yValueMapper: (data, _) => maxAmount,
          ),
          ColumnSeries<WeekWiseChartData, String>(
            dataSource: chartData,
            borderRadius: BorderRadius.circular(20.0),
            width: 0.4,
            color: Colors.blue,
            xValueMapper: (data, _) => formatChartDate(data.date),
            yValueMapper: (data, _) => data.amount,
          )
        ],
      ),
    );
  }

  String formatChartDate(DateTime date) {
    if (analysisState.filter == AnalyticsFilter.year) {
      return DateFormat.MMM().format(date);
    }
    return "${DateFormat.E().format(date)}\n${DateFormat.d().format(date)}";
  }
}
