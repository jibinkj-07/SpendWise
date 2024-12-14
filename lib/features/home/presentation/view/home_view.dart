import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../helper/home_helper.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../widgets/weekly_bar_chart.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:01:10

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Budget Card
        Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(width: .5, color: Colors.black12),
            color: Colors.blue.shade50.withOpacity(.4),
          ),
          child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (ctx, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Expense",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      DateFormat.MMMM().format(DateTime.now()),
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
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
                const SizedBox(height: 20.0),
                WeeklyBarChart(
                  chartData: generateWeekChartData(state.transactions),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
