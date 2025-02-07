part of 'month_trans_view_bloc.dart';

sealed class MonthTransViewState extends Equatable {
  const MonthTransViewState();
}

final class SubscribingMonthTransState extends MonthTransViewState {
  @override
  List<Object> get props => [];
}

final class SubscribedMonthTransState extends MonthTransViewState {
  final List<TransactionModel> transactions;

  const SubscribedMonthTransState({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

final class ErrorOccurredMonthTransState extends MonthTransViewState {
  final Failure error;

  const ErrorOccurredMonthTransState({required this.error});

  @override
  List<Object> get props => [error];
}
