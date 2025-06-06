part of 'analysis_bloc.dart';

enum AnalyticsFilter { week, month, year }

enum AnalysisStatus { loading, loaded }

class AnalysisState extends Equatable {
  final AnalyticsFilter filter;
  final AnalysisStatus status;
  final DateTime date;
  final int weekNumber;

  final List<TransactionModel> transactions;
  final List<User> budgetMembers;
  final Failure? error;

  const AnalysisState._({
    this.filter = AnalyticsFilter.month,
    this.status = AnalysisStatus.loading,
    required this.date,
    required this.weekNumber,
    this.transactions = const [],
    this.budgetMembers = const [],
    this.error,
  });

  AnalysisState.initial()
      : this._(
          date: DateTime.now(),
          weekNumber: AnalysisHelper.getWeekNumber(DateTime.now()),
        );

  AnalysisState copyWith({
    AnalyticsFilter? filter,
    AnalysisStatus? status,
    DateTime? date,
    int? weekNumber,
    List<TransactionModel>? transactions,
    List<User>? budgetMembers,
    Failure? error,
  }) =>
      AnalysisState._(
        filter: filter ?? this.filter,
        status: status ?? this.status,
        date: date ?? this.date,
        weekNumber: weekNumber ?? this.weekNumber,
        transactions: transactions ?? this.transactions,
        budgetMembers: budgetMembers ?? this.budgetMembers,
        error: error,
      );

  @override
  List<Object?> get props => [
        filter,
        date,
        transactions,
        weekNumber,
        error,
        budgetMembers,
        status,
      ];
}
