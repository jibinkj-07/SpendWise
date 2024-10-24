import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';
import 'package:my_budget/features/mobile_view/goal/data/repo/goal_repo.dart';

import '../../../../../core/util/error/failure.dart';
import '../../data/model/goal_model.dart';

part 'goal_event.dart';

part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepo _goalRepo;

  GoalBloc(this._goalRepo) : super(const GoalState.initial()) {
    on<GetGoal>(_getGoal);
    on<AddGoal>(_addGoal);
    on<DeleteGoal>(_deleteGoal);
    on<AddGoalTransaction>(_addGoalTransaction);
    on<DeleteGoalTransaction>(_deleteGoalTransaction);
  }

  Future<void> _getGoal(GetGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.loading));

    try {
      final result = await _goalRepo.getGoal(adminId: event.adminId);
      result.fold(
        (failure) => emit(GoalState.error(failure)),
        (goals) => emit(state.copyWith(
          status: GoalStatus.idle,
          goals: goals..sort((a, b) => b.createdOn.compareTo(a.createdOn)),
          error: null,
        )),
      );
    } catch (e) {
      _handleError(e, "_getGoal", emit);
    }
  }

  Future<void> _addGoal(AddGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.adding));

    if (_goalExists(event.model.title)) {
      emit(state.copyWith(
        error: Failure(message: "Goal already exists"),
        status: GoalStatus.idle,
      ));
      return;
    }

    try {
      final result = await _goalRepo.addGoal(
          goalModel: event.model, adminId: event.adminId);
      result.fold(
        (failure) =>
            emit(state.copyWith(status: GoalStatus.idle, error: failure)),
        (newGoal) => emit(state.copyWith(
          status: GoalStatus.added,
          goals: [...state.goals, newGoal]
            ..sort((a, b) => b.createdOn.compareTo(a.createdOn)),
          error: null,
        )),
      );
    } catch (e) {
      _handleError(e, "_addGoal", emit);
    }
  }

  Future<void> _deleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.deleting));

    try {
      final result = await _goalRepo.deleteGoal(
          adminId: event.adminId, goalId: event.goalId);
      result.fold(
        (failure) =>
            emit(state.copyWith(status: GoalStatus.idle, error: failure)),
        (_) => emit(state.copyWith(
          status: GoalStatus.deleted,
          goals: _removeGoalById(event.goalId),
          error: null,
        )),
      );
    } catch (e) {
      _handleError(e, "_deleteGoal", emit);
    }
  }

  Future<void> _addGoalTransaction(
      AddGoalTransaction event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.transAdding));

    try {
      final goalIndex = _findGoalIndexById(event.goalId);
      if (goalIndex < 0) {
        emit(state.copyWith(
            error: Failure(message: "Goal not found"),
            status: GoalStatus.idle));
        return;
      }

      final result = await _goalRepo.addGoalTransaction(
        model: event.model,
        goalId: event.goalId,
        adminId: event.adminId,
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: GoalStatus.idle, error: failure)),
        (newTransaction) {
          final updatedGoals =
              _updateGoalTransactions(goalIndex, newTransaction, add: true);
          emit(state.copyWith(
            status: GoalStatus.transAdded,
            goals: updatedGoals,
            error: null,
          ));
        },
      );
    } catch (e) {
      _handleError(e, "_addGoalTransaction", emit);
    }
  }

  Future<void> _deleteGoalTransaction(
      DeleteGoalTransaction event, Emitter<GoalState> emit) async {
    emit(state.copyWith(status: GoalStatus.deleting));

    try {
      final goalIndex = _findGoalIndexById(event.goalId);
      if (goalIndex < 0) {
        emit(state.copyWith(
            error: Failure(message: "Goal not found"),
            status: GoalStatus.idle));
        return;
      }

      final result = await _goalRepo.deleteGoalTransaction(
        adminId: event.adminId,
        goalId: event.goalId,
        transactionId: event.transactionId,
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: GoalStatus.idle, error: failure)),
        (_) {
          final updatedGoals = _updateGoalTransactions(
              goalIndex, event.transactionId,
              add: false);
          emit(state.copyWith(
            status: GoalStatus.transDeleted,
            goals: updatedGoals,
            error: null,
          ));
        },
      );
    } catch (e) {
      _handleError(e, "_deleteGoalTransaction", emit);
    }
  }

  bool _goalExists(String title) {
    return state.goals
        .any((goal) => goal.title.toLowerCase() == title.toLowerCase());
  }

  int _findGoalIndexById(String goalId) {
    return state.goals.indexWhere((goal) => goal.id == goalId);
  }

  List<GoalModel> _removeGoalById(String goalId) {
    return state.goals.where((goal) => goal.id != goalId).toList();
  }

  List<GoalModel> _updateGoalTransactions(int goalIndex, dynamic transaction,
      {required bool add}) {
    final goal = state.goals[goalIndex];
    final updatedTransactions =
        List<GoalTransactionModel>.from(goal.transactions);

    if (add) {
      updatedTransactions.add(transaction);
    } else {
      updatedTransactions.removeWhere((tx) => tx.id == transaction);
    }

    updatedTransactions.sort((a, b) => b.createdOn.compareTo(a.createdOn));

    final updatedGoal = goal.copyWith(transactions: updatedTransactions);
    final updatedGoals = List<GoalModel>.from(state.goals);
    updatedGoals[goalIndex] = updatedGoal;

    return updatedGoals;
  }

  void _handleError(Object e, String methodName, Emitter<GoalState> emit) {
    log("Error[$methodName][goal_bloc.dart]: $e");
    emit(state.copyWith(
        status: GoalStatus.idle,
        error: Failure(message: "An unexpected error occurred")));
  }

  @override
  void onEvent(GoalEvent event) {
    super.onEvent(event);
    log("GoalEvent dispatched: $event");
  }
}
