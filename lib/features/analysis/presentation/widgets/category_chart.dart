import 'package:flutter/material.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../../core/util/widget/empty.dart';
import '../bloc/analysis_bloc.dart';

/// @author : Jibin K John
/// @date   : 08/01/2025
/// @time   : 21:43:18

class CategoryChart extends StatelessWidget {
  final AnalysisState analysisState;
  final ValueNotifier<bool> viewAllCategory;
  final List<CategoryChartData> chartData;
  final double total;

  const CategoryChart({
    super.key,
    required this.analysisState,
    required this.viewAllCategory,
    required this.chartData,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final int limit = 4;

    return Container(
      padding: EdgeInsets.only(
        top: chartData.length > limit ? 0 : 15.0,
        bottom: 15.0,
        left: 15.0,
        right: 15.0,
      ),
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
          /// Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              if (chartData.length > limit)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ValueListenableBuilder(
                    valueListenable: viewAllCategory,
                    builder: (ctx, allCategory, _) {
                      return TextButton(
                        onPressed: () =>
                            viewAllCategory.value = !viewAllCategory.value,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          allCategory ? "Show Less" : "Show All",
                          style: TextStyle(fontSize: 13.0),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          if (chartData.isEmpty)
            SizedBox(
              height: 200.0,
              child: Empty(
                message: "No data found",
              ),
            ),
          if (chartData.length <= limit) const SizedBox(height: 10.0),
          ValueListenableBuilder(
              valueListenable: viewAllCategory,
              builder: (ctx, allCategory, _) {
                int length = chartData.length > limit
                    ? allCategory
                        ? chartData.length
                        : limit
                    : chartData.length;

                return Column(
                  children: List.generate(
                    length,
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
                );
              }),
        ],
      ),
    );
  }
}
