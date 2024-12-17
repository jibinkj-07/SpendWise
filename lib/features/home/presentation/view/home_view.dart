import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../helper/home_helper.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../widgets/monthly_transaction_history.dart';
import '../widgets/weekly_bar_chart.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:01:10

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (ctx, state) {
      if (state.status == TransactionStatus.loading) {
        return CustomLoading();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Budget Card
          Container(
            padding: const EdgeInsets.all(25.0),
            margin: const EdgeInsets.only(top: 30.0, bottom: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Expense",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          AppHelper.formatAmount(
                            context,
                            TransactionHelper.findTotal(state.transactions),
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat.MMMM().format(DateTime.now()),
                      style: TextStyle(
                        // color: AppConfig.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                WeeklyBarChart(
                  chartData: generateWeekChartData(state.transactions),
                ),
              ],
            ),
          ),

          // Transactions History
          Expanded(
            child: MonthlyTransactionHistory(transactions: state.transactions),
          ),
        ],
      );
    });
  }
}
