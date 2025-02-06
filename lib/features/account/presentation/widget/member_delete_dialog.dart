import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/widget/custom_loading.dart';
import '../bloc/account_bloc.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 17:44:01

class MemberDeleteDialog extends StatelessWidget {
  final String memberId;
  final String budgetId;
  final String budgetName;
  final bool isJoinRequest;

  const MemberDeleteDialog({
    super.key,
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
    required this.isJoinRequest,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<AccountBloc, AccountState>(
        builder: (ctx, state) {
          final isDeleting = state is Deleting;
          return AlertDialog(
            title: Text(isDeleting ? "Deleting" : "Remove Member"),
            content: isDeleting
                ? SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: CustomLoading(),
                  )
                : Text("Are you sure you want to remove this member?"),
            actions: isDeleting
                ? null
                : [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black54),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => context.read<AccountBloc>().add(
                            DeleteMember(
                              isJoinRequest: isJoinRequest,
                              budgetName: budgetName,
                              budgetId: budgetId,
                              memberId: memberId,
                            ),
                          ),
                      child: Text("Remove"),
                    ),
                  ],
          );
        },
        listener: (BuildContext context, AccountState state) {
          if (state is AccountStateError) {
            Navigator.pop(context);
            state.error.showSnackBar(context);
          }
          if (state is Deleted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
