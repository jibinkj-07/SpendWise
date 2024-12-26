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

class InsertBudget extends BudgetEvent {
  final String name;
  final String admin;
  final Currency currency;
  final List<CategoryModel> categories;
  final List<User> members;

  const InsertBudget({
    required this.name,
    required this.admin,
    required this.currency,
    required this.categories,
    required this.members,
  });

  @override
  List<Object?> get props => [name, admin, currency, categories, members];
}

class RemoveBudget extends BudgetEvent {
  final String budgetId;

  const RemoveBudget({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

class ThrownError extends BudgetEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
