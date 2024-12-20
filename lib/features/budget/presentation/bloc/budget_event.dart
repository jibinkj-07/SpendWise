part of 'budget_bloc.dart';

sealed class BudgetEvent extends Equatable {
  const BudgetEvent();
}

class SubscribeBudget extends BudgetEvent {
  final String budgetId;

  const SubscribeBudget({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

class BudgetLoaded extends BudgetEvent {
  final BudgetModel budget;

  const BudgetLoaded({required this.budget});

  @override
  List<Object?> get props => [budget];
}

class ThrownError extends BudgetEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
