part of 'expense_bloc.dart';

enum ExpenseStatus {
  idle,
  expenseFetching,
  expenseCreating,
  expenseCreated,
  expenseDeleting,
  expenseDeleted,
  categoryCreating,
  categoryCreated,
  categoryDeleting,
  categoryDeleted,
  transactionCreating,
  transactionCreated,
  transactionDeleting,
  transactionDeleted,
}

class ExpenseState extends Equatable {
  final ExpenseStatus expenseStatus;
  final ExpenseModel? currentExpense;
  final Failure? error;

  const ExpenseState._({
    this.expenseStatus = ExpenseStatus.expenseFetching,
    this.currentExpense,
    this.error,
  });

  const ExpenseState.initial() : this._();

  const ExpenseState.error(Failure message) : this._(error: message);

  ExpenseState copyWith({
    ExpenseModel? currentExpense,
    ExpenseStatus? expenseStatus,
    Failure? error,
  }) =>
      ExpenseState._(
        currentExpense: currentExpense ?? this.currentExpense,
        expenseStatus: expenseStatus ?? this.expenseStatus,
        error: error,
      );

  @override
  List<Object?> get props => [currentExpense, expenseStatus, error];
}
