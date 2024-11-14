import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../model/category_model.dart';
import '../model/expense_model.dart';
import '../model/transaction_model.dart';

abstract class ExpenseRepo {
  /// Category
  Future<Either<Failure, bool>> insertCategory({
    required String expenseId,
    required CategoryModel category,
  });

  Future<Either<Failure, bool>> removeCategory({
    required String expenseId,
    required String categoryId,
  });

  /// Transaction
  Future<Either<Failure, String>> insertTransaction({
    required String expenseId,
    required TransactionModel transaction,
    XFile? doc,
  });

  Future<Either<Failure, bool>> removeTransaction({
    required String expenseId,
    required String transactionId,
  });

  /// Expense
  Future<Either<Failure, bool>> insertExpense({
    required ExpenseModel expense,
  });

  Future<Either<Failure, bool>> removeExpense({
    required String expenseId,
  });
}
