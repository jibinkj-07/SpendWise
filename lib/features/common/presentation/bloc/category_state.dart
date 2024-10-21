part of 'category_bloc.dart';

enum CategoryStatus { idle, loading, adding, added, deleting, deleted }

class CategoryState extends Equatable {
  final CategoryStatus categoryStatus;
  final List<CategoryModel> categoryList;
  final Failure? error;

  const CategoryState._({
    this.categoryStatus = CategoryStatus.idle,
    this.categoryList = const [],
    this.error,
  });

  const CategoryState.initial() : this._();

  const CategoryState.error(Failure message) : this._(error: message);

  CategoryState copyWith({
    CategoryStatus? categoryStatus,
    List<CategoryModel>? categoryList,
    Failure? error,
  }) =>
      CategoryState._(
        categoryStatus: categoryStatus ?? this.categoryStatus,
        categoryList: categoryList ?? this.categoryList,
        error: error,
      );

  @override
  List<Object?> get props => [
        categoryStatus,
        categoryList,
        error,
      ];
}
