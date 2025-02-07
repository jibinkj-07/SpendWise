part of 'budget_view_bloc.dart';

sealed class BudgetViewState extends Equatable {
  const BudgetViewState();
}

final class BudgetSubscribing extends BudgetViewState {
  @override
  List<Object?> get props => [];
}

final class BudgetSubscribed extends BudgetViewState {
  final BudgetModel budget;

  const BudgetSubscribed({required this.budget});

  @override
  List<Object?> get props => [budget];
}

final class BudgetViewError extends BudgetViewState {
  final Failure error;

  const BudgetViewError({required this.error});

  @override
  List<Object?> get props => [error];
}
