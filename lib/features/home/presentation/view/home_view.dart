import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../helper/home_helper.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../bloc/home_transaction_bloc.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../widgets/budget_card.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/weekly_bar_chart.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:01:10

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<HomeTransactionBloc, HomeTransactionState>(
        builder: (ctx, state) {
      if (state.status == HomeTransactionStatus.loading) {
        return CustomLoading();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BudgetCard(size: size, transactions: state.transactions),
          // Transactions History
          Expanded(
            child: RecentTransactions(
              transactions: generateWeekTransactions(state.transactions),
              size: size,
            ),
          ),
        ],
      );
    });
  }
}
