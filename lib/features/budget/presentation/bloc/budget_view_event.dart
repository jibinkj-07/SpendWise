part of 'budget_view_bloc.dart';

sealed class BudgetViewEvent extends Equatable {
  const BudgetViewEvent();
}

final class SubscribeBudget extends BudgetViewEvent {
  final String budgetId;

  const SubscribeBudget({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class CancelSubscription extends BudgetViewEvent {
  const CancelSubscription();

  @override
  List<Object?> get props => [];
}

final class BudgetLoaded extends BudgetViewEvent {
  final BudgetModel budget;

  const BudgetLoaded({required this.budget});

  @override
  List<Object?> get props => [budget];
}

class BudgetViewErrorOccurred extends BudgetViewEvent {
  final Failure error;

  const BudgetViewErrorOccurred({required this.error});

  @override
  List<Object?> get props => [error];
}
