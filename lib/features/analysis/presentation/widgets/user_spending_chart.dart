import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../account/presentation/widget/display_image.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../bloc/analysis_bloc.dart';
import '../view/members_detail_view.dart';

/// @author : Jibin K John
/// @date   : 12/01/2025
/// @time   : 12:50:55

class UserSpendingChart extends StatelessWidget {
  final List<MembersChartData> chartData;
  final double total;
  final AnalysisState analysisState;

  const UserSpendingChart({
    super.key,
    required this.analysisState,
    required this.chartData,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final total = TransactionHelper.findTotal(analysisState.transactions);
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
              data.user.name.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontFamily: AppConfig.fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              AppHelper.formatAmount(
                context,
                data.amount,
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontFamily: AppConfig.fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );

    if (analysisState.budgetMembers.isNotEmpty) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Spending Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MembersDetailView(
                            chartData: chartData,
                            total: total,
                            analysisState: analysisState,
                          ),
                        ),
                      );
                    },
                    child: Text("Detail"))
              ],
            ),
            if (total > 0)
              SfCircularChart(
                margin: EdgeInsets.zero,
                tooltipBehavior: tooltipBehavior,
                series: <CircularSeries>[
                  DoughnutSeries<MembersChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data.user.name,
                    pointColorMapper: (data, _) => data.color,
                    yValueMapper: (data, _) => data.amount,
                    enableTooltip: true,
                    innerRadius: "80",
                    explode: true,
                  ),
                ],
              ),
            Column(
              children: List.generate(
                chartData.length,
                (index) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: DisplayImage(
                    height: 30.0,
                    width: 30.0,
                    imageUrl: chartData[index].user.imageUrl,
                  ),
                  // title: Text(chartData[index].user.name),
                  title: Row(
                    children: [
                      Text(
                        chartData[index].user.name,
                        style: TextStyle(fontSize: 12.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          AppHelper.formatAmount(
                            context,
                            chartData[index].amount,
                          ),
                          style: TextStyle(fontSize: 12.0),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: LinearProgressIndicator(
                    minHeight: 5.0,
                    borderRadius: BorderRadius.circular(100.0),
                    value: analysisState.transactions.isNotEmpty
                        ? chartData[index].amount / total
                        : 0,
                    color: chartData[index].color,
                    backgroundColor: chartData[index].color.withOpacity(.1),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class ChartData {
  final String name;
  final int value;

  ChartData({required this.name, required this.value});
}
