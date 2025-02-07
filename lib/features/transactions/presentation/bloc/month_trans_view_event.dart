part of 'month_trans_view_bloc.dart';

sealed class MonthTransViewEvent extends Equatable {
  const MonthTransViewEvent();
}

final class SubscribeMonthView extends MonthTransViewEvent {
  final String budgetId;
  final DateTime date;

  const SubscribeMonthView({required this.budgetId, required this.date});

  @override
  List<Object?> get props => [budgetId, date];
}

final class SubscribedMonthView extends MonthTransViewEvent {
  final List<TransactionModel> transactions;

  const SubscribedMonthView({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

final class ErrorMonthView extends MonthTransViewEvent {
  final Failure error;

  const ErrorMonthView({required this.error});

  @override
  List<Object?> get props => [error];
}
