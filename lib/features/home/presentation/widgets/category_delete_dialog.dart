import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/widget/custom_loading.dart';
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
    return PopScope(
      canPop: false,
      child: BlocConsumer<CategoryEditBloc, CategoryEditState>(
        builder: (ctx, state) {
          final isDeleting = state is DeletingCategory;
          return AlertDialog(
            title: Text(isDeleting ? "Deleting" : "Delete Category"),
            content: isDeleting
                ? SizedBox(
                    height: 60.0,
                    width: double.infinity,
                    child: CustomLoading(),
                  )
                : Text("Are you sure you want to delete this category?"),
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
                  ],
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
      ),
    );
  }
}
