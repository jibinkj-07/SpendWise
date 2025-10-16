import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../helper/home_helper.dart';
import 'weekly_bar_chart.dart';

/// @author : Jibin K John
/// @date   : 31/12/2024
/// @time   : 18:25:16

class BudgetCard extends StatelessWidget {
  final Size size;
  final List<TransactionModel> transactions;

  const BudgetCard({
    super.key,
    required this.size,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppHelper.horizontalPadding(size),
        vertical: 30.0,
      ),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15.0,
            spreadRadius: 4.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  AppHelper.formatAmount(
                    context,
                    TransactionHelper.findTotal(transactions),
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 35.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.MMMM().format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                      color: Colors.black.withValues(alpha: .7),
                    ),
                  ),
                  Text(
                    "Expense",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25.0),
          WeeklyBarChart(
            size: size,
            chartData: generateWeekChartData(transactions),
          ),
        ],
      ),
    );
  }
}
