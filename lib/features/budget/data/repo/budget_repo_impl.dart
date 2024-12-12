import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/budget_repo.dart';
import '../data_source/budget_fb_data_source.dart';

class BudgetRepoImpl implements BudgetRepo {
  final BudgetFbDataSource _expenseFbDataSource;

  BudgetRepoImpl(this._expenseFbDataSource);

  @override
  Future<Either<Failure, bool>> insertBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories, required Currency currency,
    required List<User> members,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertBudget(
        name: name,
        admin: admin,
        categories: categories,
        currency: currency,
        members: members,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> insertCategory({
    required String budgetId,
    required CategoryModel category,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertCategory(
        budgetId: budgetId,
        category: category,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, String>> insertTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertTransaction(
        budgetId: budgetId,
        transaction: transaction,
        doc: doc,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeBudget({required String budgetId}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeBudget(budgetId: budgetId);
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeCategory({
    required String budgetId,
    required String categoryId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeCategory(
        budgetId: budgetId,
        categoryId: categoryId,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeTransaction({
    required String budgetId,
    required String transactionId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeTransaction(
        budgetId: budgetId,
        transactionId: transactionId,
      );
    } else {
      return Left(Failure.network());
    }
  }
}
