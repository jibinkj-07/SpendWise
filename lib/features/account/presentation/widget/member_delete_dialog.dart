import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
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
    return BlocConsumer<AccountBloc, AccountState>(
      builder: (ctx, state) {
        final isDeleting = state is Deleting;

        return CustomAlertDialog(
          title: isDeleting ? "Removing" : "Remove Member",
          message: "Are you sure you want to remove this member",
          actionWidget: LoadingFilledButton(
            loading: isDeleting,
            isDelete: true,
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
          isLoading: isDeleting,
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
    );
  }
}
