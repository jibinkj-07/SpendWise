import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../domain/model/user.dart';
import '../helper/account_helper.dart';
import 'member_list_tile.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 12:15:15

class InvitedMembers extends StatelessWidget {
  final String budgetId;
  final String budgetName;
  final String adminId;
  final AccountHelper accountHelper;

  const InvitedMembers({
    super.key,
    required this.budgetId,
    required this.budgetName,
    required this.adminId,
    required this.accountHelper,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Either<Failure, List<User>>>(
      stream: accountHelper.subscribeMembers(budgetId: budgetId),
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
          (members) {
            if (members.isEmpty) {
              return const Empty(message: 'No Members yet');
            }

            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return MemberListTile(
                  member: member,
                  budgetId: budgetId,
                  adminId: adminId,
                  budgetName: budgetName,
                );
              },
            );
          },
        );
      },
    );
  }
}
