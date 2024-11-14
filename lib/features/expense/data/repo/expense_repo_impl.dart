import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/expense_model.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/expense_repo.dart';
import '../data_source/expense_fb_data_source.dart';

class ExpenseRepoImpl implements ExpenseRepo {
  final ExpenseFbDataSource _expenseFbDataSource;

  ExpenseRepoImpl(this._expenseFbDataSource);

  @override
  Future<Either<Failure, bool>> insertCategory({
    required String expenseId,
    required CategoryModel category,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertCategory(
        expenseId: expenseId,
        category: category,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> insertExpense({
    required ExpenseModel expense,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertExpense(
        expense: expense,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, String>> insertTransaction({
    required String expenseId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.insertTransaction(
        expenseId: expenseId,
        transaction: transaction,
        doc: doc,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeCategory({
    required String expenseId,
    required String categoryId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeCategory(
        expenseId: expenseId,
        categoryId: categoryId,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeExpense({
    required String expenseId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeExpense(
        expenseId: expenseId,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, bool>> removeTransaction({
    required String expenseId,
    required String transactionId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _expenseFbDataSource.removeTransaction(
        expenseId: expenseId,
        transactionId: transactionId,
      );
    } else {
      return Left(Failure.network());
    }
  }
}
