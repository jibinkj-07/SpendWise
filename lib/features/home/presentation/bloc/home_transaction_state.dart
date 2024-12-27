part of 'home_transaction_bloc.dart';

enum HomeTransactionStatus { idle, loading , inserting, inserted, removing, removed}

class HomeTransactionState extends Equatable {
  final HomeTransactionStatus status;
  final Failure? error;
  final List<TransactionModel> transactions;

  const HomeTransactionState._({
    this.status = HomeTransactionStatus.loading,
    this.transactions = const [],
    this.error,
  });

  const HomeTransactionState.initial() : this._();

  const HomeTransactionState.error(Failure message) : this._(error: message);

  HomeTransactionState copyWith({
    HomeTransactionStatus? status,
    List<TransactionModel>? transactions,
    Failure? error,
  }) =>
      HomeTransactionState._(
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
