part of 'category_view_bloc.dart';

sealed class CategoryViewState extends Equatable {
  const CategoryViewState();
}

final class CategorySubscribing extends CategoryViewState {
  @override
  List<Object?> get props => [];
}

final class CategorySubscribed extends CategoryViewState {
  final List<CategoryModel> categories;

  const CategorySubscribed({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class CategoryViewError extends CategoryViewState {
  final Failure error;

  const CategoryViewError({required this.error});

  @override
  List<Object?> get props => [error];
}
