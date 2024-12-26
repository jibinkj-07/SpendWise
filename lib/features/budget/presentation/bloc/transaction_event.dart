part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class SubscribeTransaction extends TransactionEvent {
  final String budgetId;
  final DateTime startDate;
  final DateTime endDate;

  const SubscribeTransaction({
    required this.budgetId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [
        budgetId,
        startDate,
        endDate,
      ];
}

class TransactionLoaded extends TransactionEvent {
  final List<TransactionModel> transactions;

  const TransactionLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class InsertTransaction extends TransactionEvent {
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

class RemoveTransaction extends TransactionEvent {
  final String budgetId;
  final String transactionId;

  const RemoveTransaction({
    required this.budgetId,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [budgetId, transactionId];
}

class ThrownError extends TransactionEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
