part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();
}

final class ExpenseInitial extends ExpenseState {
  @override
  List<Object> get props => [];
}
