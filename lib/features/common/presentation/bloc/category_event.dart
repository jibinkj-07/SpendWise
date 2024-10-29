part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetAllCategory extends CategoryEvent {
  final String adminId;

  const GetAllCategory({required this.adminId});

  @override
  List<Object?> get props => [adminId];
}

class AddCategory extends CategoryEvent {
  final CategoryModel categoryModel;
  final String adminId;

  const AddCategory({
    required this.categoryModel,
    required this.adminId,
  });

  @override
  List<Object?> get props => [categoryModel, adminId];
}

class UpdateCategory extends CategoryEvent {
  final CategoryModel categoryModel;
  final String adminId;

  const UpdateCategory({
    required this.categoryModel,
    required this.adminId,
  });

  @override
  List<Object?> get props => [categoryModel, adminId];
}

class DeleteCategory extends CategoryEvent {
  final String categoryId;
  final String adminId;

  const DeleteCategory({
    required this.adminId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [adminId, categoryId];
}
