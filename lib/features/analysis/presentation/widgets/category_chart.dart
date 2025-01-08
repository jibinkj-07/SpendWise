import 'package:flutter/material.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analytics_chart_helper.dart';

/// @author : Jibin K John
/// @date   : 08/01/2025
/// @time   : 21:43:18

class CategoryChart extends StatelessWidget {
  final AnalysisState analysisState;

  const CategoryChart({super.key, required this.analysisState});

  @override
  Widget build(BuildContext context) {
    final total = TransactionHelper.findTotal(analysisState.transactions);
    final List<CategoryChartData> chartData =
        AnalyticsChartHelper.getCategoryChartData(
      context: context,
      transactions: analysisState.transactions,
    );
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
            "Category Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Column(
            children: List.generate(
              chartData.length,
              (index) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 18.0,
                  backgroundColor:
                      chartData[index].category.color.withOpacity(.2),
                  child: Icon(
                    AppHelper.getIconFromString(
                      chartData[index].category.icon,
                    ),
                    size: 18.0,
                    color: chartData[index].category.color,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      chartData[index].category.name,
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
                  color: chartData[index].category.color,
                  backgroundColor:
                      chartData[index].category.color.withOpacity(.1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
