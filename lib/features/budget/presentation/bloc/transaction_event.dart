part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class FetchTransaction extends TransactionEvent {
  final String budgetId;
  final DateTime startDate;
  final DateTime endDate;

  const FetchTransaction({
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

class ThrownError extends TransactionEvent {
  final Failure error;

  const ThrownError({required this.error});

  @override
  List<Object?> get props => [error];
}
