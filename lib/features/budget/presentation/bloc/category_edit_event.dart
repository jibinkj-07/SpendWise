part of 'category_edit_bloc.dart';

sealed class CategoryEditEvent extends Equatable {
  const CategoryEditEvent();
}

final class AddCategory extends CategoryEditEvent {
  final String budgetId;
  final CategoryModel category;

  const AddCategory({required this.budgetId, required this.category});

  @override
  List<Object?> get props => [budgetId, category];
}

class DeleteCategory extends CategoryEditEvent {
  final String budgetId;
  final String categoryId;

  const DeleteCategory({
    required this.budgetId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [budgetId, categoryId];
}
