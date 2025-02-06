import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/access_error.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../transactions/presentation/bloc/month_trans_view_bloc.dart';
import '../helper/home_helper.dart';
import '../widgets/budget_card.dart';
import '../widgets/recent_transactions.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:01:10

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<MonthTransViewBloc, MonthTransViewState>(
        builder: (ctx, state) {
      if (state is SubscribingMonthTransState) {
        return CustomLoading();
      }

      if (state is ErrorOccurredMonthTransState) {
        return AccessError(size: size);
      }
      if (state is SubscribedMonthTransState) {
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
      }
      return const SizedBox.shrink();
    });
  }
}
