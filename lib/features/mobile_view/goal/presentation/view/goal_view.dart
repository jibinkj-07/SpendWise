import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_model.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/widget/goal_chart.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/widget/transaction_history.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../util/widget/no_access.dart';
import '../bloc/goal_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:15:40

class GoalView extends StatelessWidget {
  const GoalView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, authState) {
        if (authState.userInfo != null &&
            authState.userInfo!.adminId.isNotEmpty) {
          return BlocBuilder<GoalBloc, GoalState>(
            builder: (ctx, state) {
              if (state.status == GoalStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.goals.isEmpty) {
                return const NoAccess(
                  isEmpty: true,
                  message: "No Goal set yet",
                );
              }

              /// Getting default goal as first element in the list
              final goal = state.goals.first;
              return ListView(
                padding: const EdgeInsets.all(15.0),
                children: [
                  GoalChart(model: goal),
                  TransactionHistory(model: goal, user: authState.userInfo!),
                ],
              );
            },
          );
        }
        return const NoAccess();
      },
    );
  }
}
