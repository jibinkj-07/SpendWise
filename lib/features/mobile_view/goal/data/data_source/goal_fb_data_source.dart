import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';

import '../../../../../core/util/error/failure.dart';
import '../../../../../core/util/helper/firebase_mapper.dart';
import '../../../auth/data/data_source/auth_fb_data_source.dart';
import '../model/goal_model.dart';

abstract class GoalFbDataSource {
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

class GoalFbDataSourceImpl implements GoalFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final AuthFbDataSource _authFbDataSource;

  GoalFbDataSourceImpl(this._firebaseDatabase, this._authFbDataSource);

  @override
  Future<Either<Failure, GoalModel>> addGoal({
    required GoalModel goalModel,
    required String adminId,
  }) async {
    try {
      await _firebaseDatabase.ref(FirebaseMapper.goalPath(adminId)).update(
            goalModel.toFirebaseJson(),
          );
      return Right(goalModel);
    } catch (e) {
      log("er[addGoal][goal_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal({
    required String adminId,
    required String goalId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebaseMapper.goalPath(adminId))
          .child(goalId)
          .remove();
      return const Right(null);
    } catch (e) {
      log("er[deleteGoal][goal_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, List<GoalModel>>> getGoal({
    required String adminId,
  }) async {
    // Fetching category data of passing date year
    List<GoalModel> items = [];
    try {
      final result =
          await _firebaseDatabase.ref(FirebaseMapper.goalPath(adminId)).get();
      if (result.exists) {
        for (final goal in result.children) {
          // Getting transaction list
          List<GoalTransactionModel> transactionList = [];
          for (final transaction in goal.child("transactions").children) {
            final user = await _authFbDataSource.getUserDetail(
                uid: transaction.child("user_id").value.toString());
            if (user.isRight) {
              transactionList.add(
                GoalTransactionModel.fromFirebase(transaction, user.right),
              );
            }
          }

          final goalModel = GoalModel(
            id: goal.key.toString(),
            budget: double.parse(goal.child("budget").value.toString()),
            createdOn: DateTime.fromMillisecondsSinceEpoch(
              int.parse(goal.child("created_on").value.toString()),
            ),
            title: goal.child("title").value.toString(),
            transactions: transactionList,
          );

          items.add(goalModel);
        }
      }
      return Right(items);
    } catch (e) {
      log("er[getGoal][goal_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, GoalTransactionModel>> addGoalTransaction({
    required GoalTransactionModel model,
    required String adminId,
    required String goalId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebaseMapper.goalTransactionPath(adminId, goalId))
          .update(
            model.toFirebaseJson(),
          );
      return Right(model);
    } catch (e) {
      log("er[addGoalTransaction][goal_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoalTransaction({
    required String adminId,
    required String goalId,
    required String transactionId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebaseMapper.goalTransactionPath(adminId, goalId))
          .child(transactionId)
          .remove();
      return const Right(null);
    } catch (e) {
      log("er[deleteGoalTransaction][goal_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }
}
