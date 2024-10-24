part of 'goal_bloc.dart';

enum GoalStatus {
  idle,
  loading,
  adding,
  added,
  deleting,
  deleted,
  transAdding,
  transAdded,
  transDeleting,
  transDeleted,
}

class GoalState extends Equatable {
  final GoalStatus status;
  final List<GoalModel> goals;
  final Failure? error;

  const GoalState._({
    this.status = GoalStatus.idle,
    this.goals = const [],
    this.error,
  });

  const GoalState.initial() : this._();

  const GoalState.error(Failure message) : this._(error: message);

  GoalState copyWith({
    GoalStatus? status,
    List<GoalModel>? goals,
    Failure? error,
  }) =>
      GoalState._(
        status: status ?? this.status,
        goals: goals ?? this.goals,
        error: error,
      );

  @override
  List<Object?> get props => [
        status,
        goals,
        error,
      ];
}
