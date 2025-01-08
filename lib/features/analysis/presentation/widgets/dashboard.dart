import 'package:flutter/material.dart';
import 'package:spend_wise/core/util/widget/custom_loading.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/empty.dart';
import '../bloc/analysis_bloc.dart';
import 'category_chart.dart';
import 'summary.dart';
import 'transaction_chart.dart';

/// @author : Jibin K John
/// @date   : 07/01/2025
/// @time   : 19:54:35

class Dashboard extends StatelessWidget {
  final AnalysisState analysisState;
  final Size size;
  final VoidCallback fetchData;

  const Dashboard({
    super.key,
    required this.analysisState,
    required this.size,
    required this.fetchData,
  });

  @override
  Widget build(BuildContext context) {
    if (analysisState.error != null) {
      return Padding(
        padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              analysisState.error!.message,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            FilledButton(onPressed: fetchData, child: Text("Try again"))
          ],
        ),
      );
    }

    if (analysisState.status == AnalysisStatus.loading) {
      return CustomLoading();
    }

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppHelper.horizontalPadding(size),
        vertical: 10.0,
      ),
      children: [
        Summary(analysisState: analysisState),
        TransactionChart(analysisState: analysisState, size: size),
        CategoryChart(analysisState: analysisState)
      ],
    );
  }
}
