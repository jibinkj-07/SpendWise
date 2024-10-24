import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_model.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';

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
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, authState) {
      return ListView(
        children: [
          FilledButton(
              onPressed: () {
                context.read<GoalBloc>().add(
                      AddGoal(
                        adminId: authState.userInfo!.adminId,
                        model: GoalModel(
                          id: "goal1",
                          budget: 2000,
                          createdOn: DateTime.now(),
                          title: "Gaming Chair",
                          transactions: [],
                        ),
                      ),
                    );
              },
              child: Text("Add Goal")),
          FilledButton(
              onPressed: () {
                context.read<GoalBloc>().add(
                      DeleteGoal(
                        adminId: authState.userInfo!.adminId,
                        goalId: "goal1",
                      ),
                    );
              },
              child: Text("Delete Goal")),
          FilledButton(
              onPressed: () {
                context.read<GoalBloc>().add(
                      AddGoalTransaction(
                        model: GoalTransactionModel(
                            id: "trans2",
                            addedBy: authState.userInfo!,
                            createdOn: DateTime.now(),
                            amount: 12),
                        adminId: authState.userInfo!.adminId,
                        goalId: "goal1",
                      ),
                    );
              },
              child: Text("Add Trans")),
          FilledButton(
              onPressed: () {
                context.read<GoalBloc>().add(
                      DeleteGoalTransaction(
                          adminId: authState.userInfo!.adminId,
                          goalId: "goal1",
                          transactionId: "trans1"),
                    );
              },
              child: Text("Delete Trans")),
          BlocBuilder<GoalBloc, GoalState>(builder: (ctx, state) {
            if (state.goals.isEmpty) return Text("No Data");
            return Column(
              children: [
                Text(state.goals.first.title),
                Text(state.goals.first.budget.toString()),
                Text("Transactions"),
                for (final trans in state.goals.first.transactions)
                  Text("Added by ${trans.addedBy.name} ${trans.amount}")
              ],
            );
          }),
        ],
      );
      return NoAccess();
    });
  }
}
