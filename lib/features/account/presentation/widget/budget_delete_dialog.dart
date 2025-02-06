import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
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
    return BlocConsumer<BudgetEditBloc, BudgetEditState>(
      builder: (ctx, state) {
        final isDeleting = state is DeletingBudget;

        return CustomAlertDialog(
          title: isDeleting ? "Deleting" : "Delete Budget",
          message: "Are you sure you want to delete this budget",
          actionWidget: LoadingFilledButton(
            loading: isDeleting,
            isDelete: true,
            onPressed: () => context.read<BudgetEditBloc>().add(
                  DeleteBudget(
                    budgetId: budgetId,
                    budgetName: budgetName,
                  ),
                ),
            child: Text("Delete"),
          ),
          isLoading: isDeleting,
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
    );
  }
}
