import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../domain/model/budget_info.dart';
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
    return StreamBuilder<Either<Failure, List<BudgetInfo>>>(
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
                return InvitationTile(budget: budgets[index]);
              },
            );
          },
        );
      },
    );
  }
}
