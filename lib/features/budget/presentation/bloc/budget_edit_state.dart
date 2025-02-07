part of 'budget_edit_bloc.dart';

sealed class BudgetEditState extends Equatable {
  const BudgetEditState();
}


final class IdleBudgetState extends BudgetEditState {
  @override
  List<Object> get props => [];
}

final class AddingBudget extends BudgetEditState {
  @override
  List<Object> get props => [];
}

final class BudgetAdded extends BudgetEditState {
  @override
  List<Object> get props => [];
}

final class DeletingBudget extends BudgetEditState {
  @override
  List<Object> get props => [];
}

final class BudgetDeleted extends BudgetEditState {
  @override
  List<Object> get props => [];
}

final class BudgetErrorOccurred extends BudgetEditState {
  final Failure error;

  const BudgetErrorOccurred({required this.error});

  @override
  List<Object> get props => [error];
}
