part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class UpdateExpenseData extends ExpenseEvent {
  final ExpenseModel expense;

  const UpdateExpenseData({required this.expense});

  @override
  List<Object?> get props => [expense];
}

class SubscribeExpenseData extends ExpenseEvent {
  final String expenseId;

  const SubscribeExpenseData({
    required this.expenseId,
  });

  @override
  List<Object?> get props => [expenseId];
}

class InsertCategory extends ExpenseEvent {
  final CategoryModel category;

  const InsertCategory({
    required this.category
  });

  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends ExpenseEvent {
  final String categoryId;

  const DeleteCategory({
    required this.categoryId
  });

  @override
  List<Object?> get props => [ categoryId];
}

class InsertTransaction extends ExpenseEvent {
  final TransactionModel transaction;
  final XFile? doc;

  const InsertTransaction({
    required this.transaction,
    this.doc,
  });

  @override
  List<Object?> get props => [transaction, doc];
}

class DeleteTransaction extends ExpenseEvent {
  final String transactionId;

  const DeleteTransaction({
    required this.transactionId
  });

  @override
  List<Object?> get props => [ transactionId];
}

class InsertExpense extends ExpenseEvent {
  final ExpenseModel expense;

  const InsertExpense({
    required this.expense,
  });

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  const DeleteExpense({
    required this.expenseId,
  });

  @override
  List<Object?> get props => [expenseId];
}
