import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../model/category_model.dart';
import '../model/transaction_model.dart';

abstract class BudgetRepo {
  /// Category
  Future<Either<Failure, bool>> insertCategory({
    required String budgetId,
    required CategoryModel category,
  });

  Future<Either<Failure, bool>> removeCategory({
    required String budgetId,
    required String categoryId,
  });

  /// Transaction
  Future<Either<Failure, String>> insertTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  });

  Future<Either<Failure, bool>> removeTransaction({
    required String budgetId,
    required String transactionId,
  });

  /// Budget
  Future<Either<Failure, bool>> insertBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories,
    required Currency currency,
    required List<User> members,
  });

  Future<Either<Failure, bool>> removeBudget({
    required String budgetId,
  });
}
