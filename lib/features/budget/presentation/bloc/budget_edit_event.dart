part of 'budget_edit_bloc.dart';

sealed class BudgetEditEvent extends Equatable {
  const BudgetEditEvent();
}

final class AddBudget extends BudgetEditEvent {
  final String name;
  final String admin;
  final Currency currency;
  final List<CategoryModel> categories;
  final List<User> members;

  const AddBudget({
    required this.name,
    required this.admin,
    required this.currency,
    required this.categories,
    required this.members,
  });

  @override
  List<Object?> get props => [name, admin, currency, categories, members];
}

class DeleteBudget extends BudgetEditEvent {
  final String budgetId;
  final String budgetName;

  const DeleteBudget({
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [budgetId];
}
