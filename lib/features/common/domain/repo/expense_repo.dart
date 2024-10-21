import 'dart:io';

import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../data/model/expense_model.dart';
import '../../data/model/user_model.dart';

abstract class ExpenseRepo {
  Future<Either<Failure, ExpenseModel>> addExpense({
    required ExpenseModel expenseModel,
    required UserModel user,
    required List<File> documents,
  });

  Future<Either<Failure, void>> deleteExpense({
    required String adminId,
    required String expenseId,
  });

  Future<Either<Failure, List<ExpenseModel>>> getAllExpense(
      {required String adminId,
        required DateTime date,});
}
