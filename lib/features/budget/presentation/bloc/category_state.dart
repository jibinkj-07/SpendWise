part of 'category_bloc.dart';

enum CategoryStatus { idle, loading, inserting, inserted, removing, removed }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<CategoryModel> categories;
  final Failure? error;

  const CategoryState._({
    this.status = CategoryStatus.loading,
    this.categories = const [],
    this.error,
  });

  const CategoryState.initial() : this._();

  const CategoryState.error(Failure message) : this._(error: message);

  CategoryState copyWith({
    CategoryStatus? status,
    List<CategoryModel>? categories,
    Failure? error,
  }) =>
      CategoryState._(
        status: status ?? this.status,
        categories: categories ?? this.categories,
        error: error,
      );

  @override
  List<Object?> get props => [
        status,
        categories,
        error,
      ];
}
