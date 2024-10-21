import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../data/model/category_model.dart';

abstract class CategoryRepo {
  Future<Either<Failure, CategoryModel>> addCategory({
    required CategoryModel categoryModel,
    required String adminId,
  });

  Future<Either<Failure, void>> deleteCategory({
    required String adminId,
    required String categoryId,
  });

  Future<Either<Failure, List<CategoryModel>>> getAllCategory(
      {required String adminId});
}
