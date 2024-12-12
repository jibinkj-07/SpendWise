part of 'budget_bloc.dart';

enum BudgetStatus { idle, loading }

class BudgetState extends Equatable {
  final BudgetStatus status;
  final BudgetModel? budgetDetail;
  final Failure? error;

  const BudgetState._({
    this.status = BudgetStatus.loading,
    this.budgetDetail,
    this.error,
  });

  const BudgetState.initial() : this._();

  const BudgetState.error(Failure message) : this._(error: message);

  BudgetState copyWith({
    BudgetStatus? status,
    BudgetModel? budgetDetail,
    Failure? error,
  }) =>
      BudgetState._(
        status: status ?? this.status,
        budgetDetail: budgetDetail ?? this.budgetDetail,
        error: error,
      );

  @override
  List<Object?> get props => [
        status,
        budgetDetail,
        error,
      ];
}
