import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_mapper.dart';
import '../model/category_model.dart';

abstract class CategoryFbDataSource {
  Future<Either<Failure, CategoryModel>> addCategory({
    required CategoryModel categoryModel,
    required String adminId,
  });

  Future<Either<Failure, void>> updateCategory({
    required String adminId,
    required CategoryModel categoryModel,
  });

  Future<Either<Failure, void>> deleteCategory({
    required String adminId,
    required String categoryId,
  });

  Future<Either<Failure, List<CategoryModel>>> getAllCategory(
      {required String adminId});
}

class CategoryFbDataSourceImpl implements CategoryFbDataSource {
  final FirebaseDatabase _firebaseDatabase;

  CategoryFbDataSourceImpl(this._firebaseDatabase);

  @override
  Future<Either<Failure, CategoryModel>> addCategory({
    required CategoryModel categoryModel,
    required String adminId,
  }) async {
    try {
      await _firebaseDatabase.ref(FirebaseMapper.categoryPath(adminId)).update(
            categoryModel.toFirebaseJson(),
          );
      return Right(categoryModel);
    } catch (e) {
      log("er[addCategory][category_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory({
    required String adminId,
    required String categoryId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebaseMapper.categoryPath(adminId))
          .child(categoryId)
          .remove();
      return const Right(null);
    } catch (e) {
      log("er[deleteCategory][category_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getAllCategory(
      {required String adminId}) async {
    // Fetching category data of passing date year
    List<CategoryModel> items = [];
    try {
      final result = await _firebaseDatabase
          .ref(FirebaseMapper.categoryPath(adminId))
          .get();
      if (result.exists) {
        for (final category in result.children) {
          items.add(CategoryModel.fromFirebase(category));
        }
      }
      return Right(items);
    } catch (e) {
      log("er[getAllCategory][category_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory({
    required String adminId,
    required CategoryModel categoryModel,
  }) async {
    try {
      await _firebaseDatabase.ref(FirebaseMapper.categoryPath(adminId)).update(
            categoryModel.toFirebaseJson(),
          );
      return const Right(null);
    } catch (e) {
      log("er[updateCategory][category_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }
}
