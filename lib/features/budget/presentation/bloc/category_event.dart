part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class SubscribeCategory extends CategoryEvent {
  final String budgetId;

  const SubscribeCategory({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

class CategoryLoaded extends CategoryEvent {
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class InsertCategory extends CategoryEvent {
  final String budgetId;
  final CategoryModel category;

  const InsertCategory({required this.budgetId, required this.category});

  @override
  List<Object?> get props => [budgetId, category];
}

class RemoveCategory extends CategoryEvent {
  final String budgetId;
  final String categoryId;

  const RemoveCategory({required this.budgetId, required this.categoryId});

  @override
  List<Object?> get props => [budgetId, categoryId];
}

class ThrownError extends CategoryEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
