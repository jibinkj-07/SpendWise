import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import 'budget_switcher_tile.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 18:01:52

class BudgetSwitcher extends StatelessWidget {
  final int currentIndex;
  final BudgetModel budgetDetail;

  const BudgetSwitcher({
    super.key,
    required this.currentIndex,
    required this.budgetDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
          if (state is Authenticated) {
            return StreamBuilder<DatabaseEvent>(
                stream: FirebaseDatabase.instance
                    .ref(FirebasePath.joinedBudgetPath(state.user.uid))
                    .onValue,
                builder: (context, snapshot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select your budget",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                      snapshot.connectionState == ConnectionState.waiting
                          ? CustomLoading()
                          : snapshot.data!.snapshot.exists
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      snapshot.data!.snapshot.children.length,
                                  itemBuilder: (ctx, index) {
                                    final data = snapshot
                                        .data!.snapshot.children
                                        .toList()[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: BudgetSwitcherTile(
                                        currentIndex: currentIndex,
                                        id: data.key.toString(),
                                        budgetDetail: budgetDetail,
                                      ),
                                    );
                                  },
                                )
                              : SizedBox(
                                  height: 150.0,
                                  child: Empty(message: "No Budgets available"),
                                ),
                      const SizedBox(height: 20.0),
                      ListTile(
                        onTap: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(context, RouteName.createExpense);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        tileColor: Colors.blue.shade50,
                        leading: Icon(
                          Icons.add_circle_rounded,
                          color: AppConfig.primaryColor,
                        ),
                        title: Text(
                          "Create new budget",
                          style: TextStyle(
                            color: AppConfig.primaryColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15.0,
                          color: AppConfig.primaryColor,
                        ),
                      ),
                    ],
                  );
                });
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
