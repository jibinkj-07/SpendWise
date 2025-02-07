part of 'transaction_edit_bloc.dart';

sealed class TransactionEditState extends Equatable {
  const TransactionEditState();
}

final class IdleTransactionState extends TransactionEditState {
  @override
  List<Object> get props => [];
}

final class AddingTransaction extends TransactionEditState {
  @override
  List<Object> get props => [];
}

final class TransactionAdded extends TransactionEditState {
  @override
  List<Object> get props => [];
}

final class DeletingTransaction extends TransactionEditState {
  @override
  List<Object> get props => [];
}

final class TransactionDeleted extends TransactionEditState {
  @override
  List<Object> get props => [];
}

final class TransactionErrorOccurred extends TransactionEditState {
  final Failure error;

  const TransactionErrorOccurred({required this.error});

  @override
  List<Object> get props => [error];
}
