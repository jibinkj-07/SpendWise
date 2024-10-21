part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class GetAllExpense extends ExpenseEvent {
  final String adminId;

  const GetAllExpense({
    required this.adminId,
  });

  @override
  List<Object?> get props => [adminId];
}

class UpdateDate extends ExpenseEvent {
  final DateTime date;
  final String adminId;

  const UpdateDate({
    required this.date,
    required this.adminId,
  });

  @override
  List<Object?> get props => [date, adminId];
}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expenseModel;
  final UserModel user;
  final List<File> documents;

  const AddExpense({
    required this.expenseModel,
    required this.user,
    required this.documents,
  });

  @override
  List<Object?> get props => [expenseModel, user, documents];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;
  final String adminId;

  const DeleteExpense({
    required this.adminId,
    required this.expenseId,
  });

  @override
  List<Object?> get props => [adminId, expenseId];
}
