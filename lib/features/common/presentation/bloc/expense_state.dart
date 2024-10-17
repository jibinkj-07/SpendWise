part of 'expense_bloc.dart';

enum ExpenseStatus { idle, loading, adding, added, deleting, deleted }

class ExpenseState extends Equatable {
  final ExpenseStatus expenseStatus;
  final List<ExpenseModel> expenseList;
  final DateTime selectedDate;
  final Failure? error;

  ExpenseState._({
    this.expenseStatus = ExpenseStatus.idle,
    this.expenseList = const [],
    DateTime? selectedDate,
    this.error,
  }) : selectedDate = DateTime.now();

  ExpenseState.initial() : this._();

  ExpenseState.error(Failure message) : this._(error: message);

  ExpenseState copyWith({
    ExpenseStatus? expenseStatus,
    List<ExpenseModel>? expenseList,
    DateTime? selectedDate,
    Failure? error,
  }) =>
      ExpenseState._(
        expenseStatus: expenseStatus ?? this.expenseStatus,
        expenseList: expenseList ?? this.expenseList,
        selectedDate: selectedDate ?? this.selectedDate,
        error: error,
      );

  @override
  List<Object?> get props => [
        expenseStatus,
        expenseList,
        selectedDate,
        error,
      ];
}
