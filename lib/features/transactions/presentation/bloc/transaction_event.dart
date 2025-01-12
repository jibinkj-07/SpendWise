part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

final class SubscribeTransaction extends TransactionEvent {
  final String budgetId;

  const SubscribeTransaction({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class SubscribedTransaction extends TransactionEvent {
  final List<TransactionModel> transactions;
  final DateTime date;

  const SubscribedTransaction({
    required this.transactions,
    required this.date,
  });

  @override
  List<Object?> get props => [transactions, date];
}

final class UpdateCategory extends TransactionEvent {
  final String categoryId;

  const UpdateCategory({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

final class UpdateTransactionDate extends TransactionEvent {
  final DateTime date;
  final String budgetId;

  const UpdateTransactionDate({
    required this.date,
    required this.budgetId,
  });

  @override
  List<Object?> get props => [date, budgetId];
}

final class ErrorTransaction extends TransactionEvent {
  final Failure error;

  const ErrorTransaction({required this.error});

  @override
  List<Object?> get props => [error];
}
