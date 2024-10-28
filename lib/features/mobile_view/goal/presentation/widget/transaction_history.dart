import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/helper/goal_helper.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/view/create_transaction_screen.dart';

import '../../../../../core/config/route/route_mapper.dart';
import '../../../../common/data/model/user_model.dart';
import '../../data/model/goal_model.dart';
import '../bloc/goal_bloc.dart';

/// @author : Jibin K John
/// @date   : 24/10/2024
/// @time   : 18:44:34

class TransactionHistory extends StatelessWidget {
  final GoalModel model;
  final UserModel user;

  const TransactionHistory({
    super.key,
    required this.model,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalBloc, GoalState>(
      listener: (BuildContext context, GoalState state) {
        if (state.error != null) {
          state.error!.showSnackBar(context);
        }
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transaction History",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0,
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CreateTransactionScreen(user: user, goalId: model.id),
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          if (model.transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("No Transaction details"),
            )
          else
            for (final transaction in model.transactions)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: GoalHelper.getColorForLetter(
                    transaction.addedBy.name.substring(0, 1),
                  ),
                  child: Text(
                    transaction.addedBy.name.substring(0, 1),
                    style: TextStyle(
                      color: GoalHelper.isDarkColor(
                        GoalHelper.getColorForLetter(
                            transaction.addedBy.name.substring(0, 1)),
                      )
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                title: Text(
                  AppHelper.amountFormatter(transaction.amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  "${transaction.addedBy.name} |"
                  " ${DateFormat("dd-M-y").add_jm().format(transaction.createdOn)}",
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Delete"),
                            content: const Text(
                                "Are you sure want to delete this transaction?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.read<GoalBloc>().add(
                                        DeleteGoalTransaction(
                                          adminId: user.adminId,
                                          goalId: model.id,
                                          transactionId: transaction.id,
                                        ),
                                      );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text("Delete"),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded)),
              ),
        ],
      ),
    );
  }
}
