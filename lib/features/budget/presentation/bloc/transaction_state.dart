part of 'transaction_bloc.dart';

enum TransactionStatus { idle, loading }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final Failure? error;
  final List<TransactionModel> transactions;

  const TransactionState._({
    this.status = TransactionStatus.loading,
    this.transactions = const [],
    this.error,
  });

  const TransactionState.initial() : this._();

  const TransactionState.error(Failure message) : this._(error: message);

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? transactions,
    Failure? error,
  }) =>
      TransactionState._(
        status: status ?? this.status,
        transactions: transactions ?? this.transactions,
        error: error,
      );

  @override
  List<Object?> get props => [
        error,
        transactions,
        status,
      ];
}
