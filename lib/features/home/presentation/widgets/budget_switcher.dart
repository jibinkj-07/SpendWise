
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'budget_switcher_tile.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 18:01:52

class BudgetSwitcher extends StatelessWidget {
  const BudgetSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * .45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
        if (state is Authenticated) {
          return StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref(FirebasePath.joinedBudgetPath(state.user.uid))
                  .onValue,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close_rounded),
                      ),
                    ),
                    Expanded(
                      child: snapshot.connectionState == ConnectionState.waiting
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: BudgetSwitcherTile(
                                        id: data.key.toString(),
                                      ),
                                    );
                                  },
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("No Budgets available"),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context)
                                            .pushNamed(RouteName.createExpense);
                                      },
                                      child: Text("Create New"),
                                    )
                                  ],
                                ),
                    ),
                  ],
                );
              });
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
