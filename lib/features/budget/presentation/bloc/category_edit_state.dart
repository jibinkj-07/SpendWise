part of 'category_edit_bloc.dart';

sealed class CategoryEditState extends Equatable {
  const CategoryEditState();
}


final class IdleCategoryState extends CategoryEditState {
  @override
  List<Object> get props => [];
}

final class AddingCategory extends CategoryEditState {
  @override
  List<Object> get props => [];
}

final class CategoryAdded extends CategoryEditState {
  @override
  List<Object> get props => [];
}

final class DeletingCategory extends CategoryEditState {
  @override
  List<Object> get props => [];
}

final class CategoryDeleted extends CategoryEditState {
  @override
  List<Object> get props => [];
}

final class CategoryErrorOccurred extends CategoryEditState {
  final Failure error;

  const CategoryErrorOccurred({required this.error});

  @override
  List<Object> get props => [error];
}
