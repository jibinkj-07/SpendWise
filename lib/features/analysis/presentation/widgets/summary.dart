import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/util/extension/string_ext.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_snackbar.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analysis_helper.dart';

/// @author : Jibin K John
/// @date   : 07/01/2025
/// @time   : 20:08:49

class Summary extends StatelessWidget {
  final AnalysisState analysisState;

  const Summary({super.key, required this.analysisState});

  @override
  Widget build(BuildContext context) {
    final total = TransactionHelper.findTotal(analysisState.transactions);
    final List<MapEntry<dynamic, double>> summary = AnalysisHelper.getSummary(
      analysisState.transactions,
    );

    final topDayEntry = summary.first;
    final topMonthEntry = summary[1];
    final topCategoryEntry = summary[2];
    final topItemEntry = summary.last;

    final categoryState =
        context.read<CategoryViewBloc>().state as CategorySubscribed;
    final topCategory = categoryState.categories.firstWhere(
      (item) => item.id == topCategoryEntry.key,
      orElse: () => CategoryModel.deleted(),
    );

    return Container(
      padding: const EdgeInsets.all(15.0),
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
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${analysisState.filter.name.firstLetterToUpperCase()}ly Summary",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    _getSubtitle(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  AppHelper.formatAmount(context, total),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Bottom
          const SizedBox(height: 20.0),
          // Text(summary.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _container(
                "Day",
                DateFormat("dd E").format(topDayEntry.key),
                topDayEntry.value,
                total,
                context,
              ),
              const SizedBox(width: 10.0),
              _container(
                "Category",
                topCategory.name,
                topCategoryEntry.value,
                total,
                context,
                AppConfig.focusColor,
              ),
              const SizedBox(width: 10.0),
              _container(
                "Item",
                (topItemEntry.key as TransactionModel).title,
                topItemEntry.value,
                total,
                context,
                Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _container(String title, String subtitle, double amount, double total,
      BuildContext context,
      [Color? color]) {
    final boxColor =
        color == null ? Colors.blue.shade200 : color.withOpacity(.5);
    final value = AppHelper.formatAmount(context, amount);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CustomSnackBar.showInfoSnackBar(context, "$subtitle ${value}");
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: boxColor.withOpacity(.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  CircularProgressIndicator(
                    value: amount / total,
                    color: color,
                    backgroundColor: boxColor,
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitle() {
    switch (analysisState.filter) {
      case AnalyticsFilter.week:
        {
          final start = AnalysisHelper.getStartOfWeek(
            analysisState.date.year,
            analysisState.date.month,
            analysisState.weekNumber,
          );
          final end = AnalysisHelper.getEndOfWeek(
            analysisState.date.year,
            analysisState.date.month,
            analysisState.weekNumber,
          );
          return "${DateFormat("dd MMM, E").format(start)} - ${DateFormat("dd MMM, E").format(end)}";
        }

      case AnalyticsFilter.month:
        return DateFormat.MMMM().format(analysisState.date);
      case AnalyticsFilter.year:
        return "${analysisState.date.year}";
    }
  }
}
