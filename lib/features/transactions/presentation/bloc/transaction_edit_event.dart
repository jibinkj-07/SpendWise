part of 'transaction_edit_bloc.dart';

sealed class TransactionEditEvent extends Equatable {
  const TransactionEditEvent();
}

final class AddTransaction extends TransactionEditEvent {
  final String budgetId;
  final TransactionModel transaction;
  final XFile? doc;

  const AddTransaction({
    required this.budgetId,
    required this.transaction,
    required this.doc,
  });

  @override
  List<Object?> get props => [budgetId, transaction, doc];
}


final class UpdateTransaction extends TransactionEditEvent {
  final String budgetId;
  final TransactionModel transaction;
  final DateTime oldTransactionDate;
  final XFile? doc;

  const UpdateTransaction({
    required this.budgetId,
    required this.transaction,
    required this.oldTransactionDate,
    required this.doc,
  });

  @override
  List<Object?> get props => [budgetId, transaction, doc];
}

final class DeleteTransaction extends TransactionEditEvent {
  final String budgetId;
  final String transactionId;
  final DateTime createdDate;

  const DeleteTransaction({
    required this.budgetId,
    required this.transactionId,
    required this.createdDate,
  });

  @override
  List<Object?> get props => [budgetId, transactionId, createdDate];
}
