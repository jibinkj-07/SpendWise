part of 'goal_bloc.dart';

sealed class GoalEvent extends Equatable {
  const GoalEvent();
}

class GetGoal extends GoalEvent {
  final String adminId;

  const GetGoal({required this.adminId});

  @override
  List<Object?> get props => [adminId];
}

class AddGoal extends GoalEvent {
  final String adminId;
  final GoalModel model;

  const AddGoal({
    required this.adminId,
    required this.model,
  });

  @override
  List<Object?> get props => [adminId, model];
}

class DeleteGoal extends GoalEvent {
  final String adminId;
  final String goalId;

  const DeleteGoal({
    required this.adminId,
    required this.goalId,
  });

  @override
  List<Object?> get props => [adminId, goalId];
}

class AddGoalTransaction extends GoalEvent {
  final String adminId;
  final String goalId;
  final GoalTransactionModel model;

  const AddGoalTransaction({
    required this.adminId,
    required this.goalId,
    required this.model,
  });

  @override
  List<Object?> get props => [adminId, goalId, model];
}

class DeleteGoalTransaction extends GoalEvent {
  final String adminId;
  final String goalId;
  final String transactionId;

  const DeleteGoalTransaction({
    required this.adminId,
    required this.goalId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [adminId, goalId, transactionId];
}
