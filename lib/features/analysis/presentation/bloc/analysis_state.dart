part of 'analysis_bloc.dart';

enum AnalyticsFilter { week, month, year }

enum AnalysisStatus { loading, loaded }

class AnalysisState extends Equatable {
  final AnalyticsFilter filter;
  final AnalysisStatus status;
  final DateTime date;
  final int weekNumber;

  final List<TransactionModel> transactions;
  final Failure? error;

  const AnalysisState._({
    this.filter = AnalyticsFilter.month,
    this.status = AnalysisStatus.loading,
    required this.date,
    this.weekNumber = 1,
    this.transactions = const [],
    this.error,
  });

  AnalysisState.initial() : this._(date: DateTime.now());

  AnalysisState copyWith({
    AnalyticsFilter? filter,
    AnalysisStatus? status,
    DateTime? date,
    int? weekNumber,
    List<TransactionModel>? transactions,
    Failure? error,
  }) =>
      AnalysisState._(
        filter: filter ?? this.filter,
        status: status ?? this.status,
        date: date ?? this.date,
        weekNumber: weekNumber ?? this.weekNumber,
        transactions: transactions ?? this.transactions,
        error: error,
      );



  @override
  List<Object?> get props => [
        filter,
        date,
        transactions,
        weekNumber,
        error,
        status,
      ];
}
