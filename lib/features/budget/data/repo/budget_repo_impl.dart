import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:spend_wise/features/budget/domain/model/budget_model.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';
import '../data_source/budget_fb_data_source.dart';

class BudgetRepoImpl implements BudgetRepo {
  final BudgetFbDataSource _expenseFbDataSource;

  BudgetRepoImpl(this._expenseFbDataSource);

  @override
  Future<Either<Failure, bool>> addBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories,
    required Currency currency,
    required List<User> members,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.addBudget(
        name: name,
        admin: admin,
        categories: categories,
        currency: currency,
        members: members,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> addCategory({
    required String budgetId,
    required CategoryModel category,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.addCategory(
        budgetId: budgetId,
        category: category,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBudget({
    required String budgetId,
    required String budgetName,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.deleteBudget(
        budgetId: budgetId,
        budgetName: budgetName,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory({
    required String budgetId,
    required String categoryId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.deleteCategory(
        budgetId: budgetId,
        categoryId: categoryId,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Stream<Either<Failure, BudgetModel>> subscribeBudget({
    required String budgetId,
  }) async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _expenseFbDataSource.subscribeBudget(budgetId: budgetId);
    } else {
      yield Left(NetworkError());
    }
  }

  @override
  Stream<Either<Failure, List<CategoryModel>>> subscribeCategory(
      {required String budgetId}) async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _expenseFbDataSource.subscribeCategory(budgetId: budgetId);
    } else {
      yield Left(NetworkError());
    }
  }
}
