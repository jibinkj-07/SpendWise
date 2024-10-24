import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_budget/core/util/error/failure.dart';

import '../../domain/repo/category_repo.dart';
import '../data_source/category_fb_data_source.dart';
import '../model/category_model.dart';

class CategoryRepoImpl implements CategoryRepo {
  final CategoryFbDataSource _expenseFbDataSource;

  CategoryRepoImpl(this._expenseFbDataSource);

  @override
  Future<Either<Failure, CategoryModel>> addCategory({
    required CategoryModel categoryModel,
    required String adminId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.addCategory(
        categoryModel: categoryModel,
        adminId: adminId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory({
    required String adminId,
    required String categoryId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.deleteCategory(
        adminId: adminId,
        categoryId: categoryId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategory(
      {required String adminId}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.getAllCategory(adminId: adminId);
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }
}
