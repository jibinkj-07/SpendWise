import 'package:either_dart/either.dart';

import '../../../../../core/util/error/failure.dart';
import '../model/goal_model.dart';
import '../model/goal_transaction_model.dart';

abstract class GoalRepo {
  Future<Either<Failure, GoalModel>> addGoal({
    required GoalModel goalModel,
    required String adminId,
  });

  Future<Either<Failure, void>> deleteGoal({
    required String adminId,
    required String goalId,
  });

  Future<Either<Failure, List<GoalModel>>> getGoal({required String adminId});

  Future<Either<Failure, GoalTransactionModel>> addGoalTransaction({
    required GoalTransactionModel model,
    required String adminId,
    required String goalId,
  });

  Future<Either<Failure, void>> deleteGoalTransaction({
    required String adminId,
    required String goalId,
    required String transactionId,
  });
}
