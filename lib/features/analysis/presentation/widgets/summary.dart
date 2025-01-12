import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_snackbar.dart';
import '../../../budget/domain/model/category_model.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../bloc/analysis_bloc.dart';
import '../helper/analysis_helper.dart';

/// @author : Jibin K John
/// @date   : 07/01/2025
/// @time   : 20:08:49

class Summary extends StatelessWidget {
  final AnalysisState analysisState;
  final List<MapEntry<dynamic, double>> summary;
  final double total;

  const Summary({
    super.key,
    required this.analysisState,
    required this.summary,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Spending Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    _getSubtitle(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
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
                    fontSize: 18.0,
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
              if (analysisState.filter == AnalyticsFilter.year)
                _container(
                  "Month",
                  DateFormat.MMMM().format(topMonthEntry.key),
                  topMonthEntry.value,
                  total,
                  context,
                )
              else
                _container(
                  "Day",
                  DateFormat("dd EEEE").format(topDayEntry.key),
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
    final bgColor =
        color == null ? Colors.blue.shade200 : color.withOpacity(.3);
    final value = AppHelper.formatAmount(
      context,
      amount,
      decimalDigits: amount > 1000 ? 0 : 2,
    );
    return Expanded(
      child: GestureDetector(
        onTap: () {
          CustomSnackBar.showInfoSnackBar(context, "$subtitle $value");
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(width: .5, color: bgColor),
            borderRadius: BorderRadius.circular(15.0),
            color: bgColor.withOpacity(.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                analysisState.transactions.isNotEmpty ? subtitle : "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  SizedBox(
                    height: 28.0,
                    width: 28.0,
                    child: CircularProgressIndicator(
                      value: analysisState.transactions.isNotEmpty
                          ? (amount / total)
                          : 0,
                      color: color,
                      backgroundColor: bgColor,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Text(
                      analysisState.transactions.isNotEmpty
                          ? value
                          : AppHelper.formatAmount(context, 0),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
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
        return DateFormat.yMMMM().format(analysisState.date);
      case AnalyticsFilter.year:
        return "${analysisState.date.year}";
    }
  }
}
