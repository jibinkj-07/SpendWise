part of 'home_transaction_bloc.dart';

sealed class HomeTransactionEvent extends Equatable {
  const HomeTransactionEvent();
}

class SubscribeTransaction extends HomeTransactionEvent {
  final String budgetId;

  const SubscribeTransaction({
    required this.budgetId
  });

  @override
  List<Object?> get props => [
        budgetId
      ];
}

class TransactionLoaded extends HomeTransactionEvent {
  final List<TransactionModel> transactions;

  const TransactionLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class InsertTransaction extends HomeTransactionEvent {
  final String budgetId;
  final TransactionModel transaction;
  final XFile? doc;

  const InsertTransaction({
    required this.budgetId,
    required this.transaction,
    this.doc,
  });

  @override
  List<Object?> get props => [budgetId, transaction];
}

class RemoveTransaction extends HomeTransactionEvent {
  final String budgetId;
  final String transactionId;

  const RemoveTransaction({
    required this.budgetId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [budgetId, transactionId];
}

class ThrownError extends HomeTransactionEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
