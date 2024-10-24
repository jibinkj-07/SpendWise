import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_budget/core/util/error/failure.dart';
import 'package:my_budget/features/mobile_view/goal/data/data_source/goal_fb_data_source.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_model.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';

import 'goal_repo.dart';

class GoalRepoImpl implements GoalRepo {
  final GoalFbDataSource _goalFbDataSource;

  GoalRepoImpl(this._goalFbDataSource);

  @override
  Future<Either<Failure, GoalModel>> addGoal({
    required GoalModel goalModel,
    required String adminId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _goalFbDataSource.addGoal(
        goalModel: goalModel,
        adminId: adminId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, GoalTransactionModel>> addGoalTransaction({
    required GoalTransactionModel model,
    required String adminId,
    required String goalId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _goalFbDataSource.addGoalTransaction(
        model: model,
        adminId: adminId,
        goalId: goalId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal({
    required String adminId,
    required String goalId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _goalFbDataSource.deleteGoal(
        adminId: adminId,
        goalId: goalId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoalTransaction({
    required String adminId,
    required String goalId,
    required String transactionId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _goalFbDataSource.deleteGoalTransaction(
        adminId: adminId,
        goalId: goalId,
        transactionId: transactionId,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<GoalModel>>> getGoal({
    required String adminId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _goalFbDataSource.getGoal(adminId: adminId);
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }
}
