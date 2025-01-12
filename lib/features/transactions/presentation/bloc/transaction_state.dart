part of 'transaction_bloc.dart';

enum TransactionStatus { loading, loaded }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TransactionModel> transactions;
  final String selectedCategoryId;
  final Failure? error;
  final DateTime date;

  const TransactionState._({
    this.status = TransactionStatus.loading,
    this.selectedCategoryId = "",
    required this.date,
    this.transactions = const [],
    this.error,
  });

  TransactionState.initial() : this._(date: DateTime.now());

  TransactionState copyWith({
    TransactionStatus? status,
    DateTime? date,
    int? weekNumber,
    String? selectedCategoryId,
    List<TransactionModel>? transactions,
    Failure? error,
  }) =>
      TransactionState._(
        status: status ?? this.status,
        date: date ?? this.date,
        transactions: transactions ?? this.transactions,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
        error: error,
      );

  @override
  List<Object?> get props => [
        date,
        transactions,
        error,
        selectedCategoryId,
        status,
      ];
}
