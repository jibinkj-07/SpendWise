import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../budget/presentation/bloc/budget_edit_bloc.dart';

/// @author : Jibin K John
/// @date   : 15/01/2025
/// @time   : 11:35:55

class BudgetDeleteDialog extends StatelessWidget {
  final String budgetId;
  final String budgetName;

  const BudgetDeleteDialog({
    super.key,
    required this.budgetId,
    required this.budgetName,
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
                            DeleteBudget(
                              budgetId: budgetId,
                              budgetName: budgetName,
                            ),
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
            Navigator.of(context)
                .pushNamedAndRemoveUntil(RouteName.root, (_) => false);
          }
        },
      ),
    );
  }
}
