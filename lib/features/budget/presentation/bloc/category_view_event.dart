part of 'category_view_bloc.dart';

sealed class CategoryViewEvent extends Equatable {
  const CategoryViewEvent();
}

final class SubscribeCategory extends CategoryViewEvent {
  final String budgetId;

  const SubscribeCategory({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class CategoryLoaded extends CategoryViewEvent {
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryViewErrorOccurred extends CategoryViewEvent {
  final Failure error;

  const CategoryViewErrorOccurred({required this.error});

  @override
  List<Object?> get props => [error];
}
