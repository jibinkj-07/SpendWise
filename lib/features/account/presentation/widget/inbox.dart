import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../../root.dart';
import '../../domain/model/budget_info.dart';
import '../bloc/account_bloc.dart';
import '../helper/account_helper.dart';
import 'invitation_tile.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 18:38:25

class Inbox extends StatelessWidget {
  final String userId;
  final AccountHelper accountHelper;

  const Inbox({
    super.key,
    required this.userId,
    required this.accountHelper,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (BuildContext ctx, AccountState state) {
        if (state is AccountStateError) {
          state.error.showSnackBar(context);
        }

        if (state is Accepted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) =>
                  Root(userId: userId, budgetId: state.budgetId),
            ),
                (_) => false,
          );
        }
      },
      child: StreamBuilder<Either<Failure, List<BudgetInfo>>>(
        stream: accountHelper.subscribeInvitations(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoading();
          }

          if (snapshot.hasError) {
            return Empty(message: 'Error: ${snapshot.error}');
          }

          final data = snapshot.data;
          if (data == null) {
            return const Empty(message: 'No data available.');
          }

          return data.fold(
            (failure) => Empty(message: 'Failure: ${failure.message}'),
            (budgets) {
              if (budgets.isEmpty) {
                return const Empty(message: 'No invitations yet');
              }

              return ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  return InvitationTile(
                    budget: budgets[index],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
