import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../bloc/account_bloc.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 15:20:56

class LeaveAlertDialog extends StatelessWidget {
  final String budgetId;
  final String budgetName;
  final String userId;
  final String userName;

  const LeaveAlertDialog({
    super.key,
    required this.budgetId,
    required this.budgetName,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      builder: (ctx, state) {
        final loading = state is Leaving;

        return CustomAlertDialog(
          title: loading ? "Leaving" : "Leave Budget",
          message: "Are you sure you want to leave this budget",
          actionWidget: LoadingFilledButton(
            loading: loading,
            isDelete: true,
            onPressed: () => context.read<AccountBloc>().add(
                  LeaveBudget(
                    budgetId: budgetId,
                    budgetName: budgetName,
                    userId: userId,
                    userName: userName,
                  ),
                ),
            child: Text("Leave"),
          ),
          isLoading: loading,
        );
      },
      listener: (BuildContext context, AccountState state) {
        if (state is AccountStateError) {
          Navigator.pop(context);
          state.error.showSnackBar(context);
        }
        if (state is Left) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.root, (_) => false);
        }
      },
    );
  }
}
