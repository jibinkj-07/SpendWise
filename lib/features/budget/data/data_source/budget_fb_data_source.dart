import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spend_wise/features/budget/domain/model/goal_trans_model.dart';
import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/goal_model.dart';
import '../../domain/model/transaction_model.dart';

abstract class BudgetFbDataSource {
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

  /// Goal Transaction
  Future<Either<Failure, bool>> insertGoalTransaction({
    required String budgetId,
    required String goalId,
    required GoalTransModel transaction,
  });

  Future<Either<Failure, bool>> removeGoalTransaction({
    required String budgetId,
    required String goalId,
    required String transactionId,
  });

  /// Goal
  Future<Either<Failure, bool>> insertGoal({
    required String budgetId,
    required GoalModel goal,
  });

  Future<Either<Failure, bool>> removeGoal({
    required String budgetId,
    required String goalId,
  });

  /// Budget
  Future<Either<Failure, bool>> insertBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories,
    required List<String> accountTypes,
    required List<User> members,
  });

  Future<Either<Failure, bool>> removeBudget({
    required String budgetId,
  });
}
