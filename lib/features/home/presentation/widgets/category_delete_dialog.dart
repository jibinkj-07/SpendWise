import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../../budget/presentation/bloc/category_edit_bloc.dart';

/// @author : Jibin K John
/// @date   : 15/01/2025
/// @time   : 11:35:55

class CategoryDeleteDialog extends StatelessWidget {
  final String categoryId;

  const CategoryDeleteDialog({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryEditBloc, CategoryEditState>(
      builder: (ctx, state) {
        final isDeleting = state is DeletingCategory;

        return CustomAlertDialog(
          title: isDeleting ? "Deleting" : "Delete Category",
          message: "Are you sure you want to delete this category",
          actionWidget: LoadingFilledButton(
            loading: isDeleting,
            isDelete: true,
            onPressed: () => context.read<CategoryEditBloc>().add(
                  DeleteCategory(
                    budgetId: (context.read<BudgetViewBloc>().state
                            as BudgetSubscribed)
                        .budget
                        .id,
                    categoryId: categoryId,
                  ),
                ),
            child: Text("Delete"),
          ),
          isLoading: isDeleting,
        );
      },
      listener: (BuildContext context, CategoryEditState state) {
        if (state is CategoryErrorOccurred) {
          Navigator.pop(context);
          state.error.showSnackBar(context);
        }

        if (state is CategoryDeleted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      },
    );
  }
}
