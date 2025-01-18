import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../root.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/presentation/bloc/budget_edit_bloc.dart';

/// @author : Jibin K John
/// @date   : 15/01/2025
/// @time   : 11:35:55

class BudgetDeleteDialog extends StatelessWidget {
  final String budgetId;

  const BudgetDeleteDialog({
    super.key,
    required this.budgetId,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<BudgetEditBloc, BudgetEditState>(
        builder: (ctx, state) {
          final isDeleting = state is DeletingBudget;
          return AlertDialog(
            title: Text(isDeleting ? "Deleting" : "Delete Budget"),
            content: isDeleting
                ? SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: CustomLoading(),
                  )
                : Text("Are you sure you want to delete this budget?"),
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
                      onPressed: () => context.read<BudgetEditBloc>().add(
                            DeleteBudget(budgetId: budgetId),
                          ),
                      child: Text("Delete"),
                    ),
                  ],
          );
        },
        listener: (BuildContext context, BudgetEditState state) {
          if (state is BudgetErrorOccurred) {
            Navigator.pop(context);
            state.error.showSnackBar(context);
          }
          if (state is BudgetDeleted) {
            Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => Root(
                    userId: (context.read<AuthBloc>().state as Authenticated)
                        .user
                        .uid,
                  ),
                ),
                (_) => false);
          }
        },
      ),
    );
  }
}
