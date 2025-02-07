part of 'analysis_bloc.dart';

sealed class AnalysisEvent extends Equatable {
  const AnalysisEvent();
}

final class SubscribeAnalysisData extends AnalysisEvent {
  final String budgetId;

  const SubscribeAnalysisData({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class SubscribedAnalysis extends AnalysisEvent {
  final List<TransactionModel> transactions;
  final String budgetId;

  const SubscribedAnalysis({
    required this.transactions,
    required this.budgetId,
  });

  @override
  List<Object?> get props => [transactions, budgetId];
}

final class GetMembers extends AnalysisEvent {
  final String budgetId;

  const GetMembers({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

final class Error extends AnalysisEvent {
  final Failure error;

  const Error({required this.error});

  @override
  List<Object?> get props => [error];
}

final class UpdateAnalysisFilter extends AnalysisEvent {
  final AnalyticsFilter analyticsFilter;

  const UpdateAnalysisFilter({required this.analyticsFilter});

  @override
  List<Object?> get props => [analyticsFilter];
}

final class UpdateDate extends AnalysisEvent {
  final DateTime date;
  final String budgetId;
  final int weekNumber;

  const UpdateDate({
    required this.date,
    required this.budgetId,
    required this.weekNumber,
  });

  @override
  List<Object?> get props => [date, weekNumber, budgetId];
}

final class CancelAnalysisSubscription extends AnalysisEvent {
  @override
  List<Object?> get props => [];
}
