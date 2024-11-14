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
  final String expenseId;
  final CategoryModel category;

  const InsertCategory({
    required this.expenseId,
    required this.category,
  });

  @override
  List<Object?> get props => [expenseId, category];
}

class DeleteCategory extends ExpenseEvent {
  final String expenseId;
  final String categoryId;

  const DeleteCategory({
    required this.expenseId,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [expenseId, categoryId];
}

class InsertTransaction extends ExpenseEvent {
  final String expenseId;
  final TransactionModel transaction;
  final XFile? doc;

  const InsertTransaction({
    required this.expenseId,
    required this.transaction,
    this.doc,
  });

  @override
  List<Object?> get props => [expenseId, transaction, doc];
}

class DeleteTransaction extends ExpenseEvent {
  final String expenseId;
  final String transactionId;

  const DeleteTransaction({
    required this.expenseId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [expenseId, transactionId];
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
