import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../../domain/repo/analysis_repo.dart';
import '../helper/analysis_helper.dart';

part 'analysis_event.dart';

part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisRepo _analysisRepo;

  late List<TransactionModel> _transactions; // `late` to initialize lazily
  StreamSubscription? _analysisSubscription;

  AnalysisBloc(this._analysisRepo) : super(AnalysisState.initial()) {
    on<SubscribeAnalysisData>(_onSubscribe);
    on<SubscribedAnalysis>(_onSubscribed);
    on<Error>(_onError);
    on<UpdateAnalysisFilter>(_onUpdateFilter);
    on<UpdateDate>(_onUpdateDate);
  }

  @override
  Future<void> close() {
    _analysisSubscription?.cancel();
    return super.close();
  }

  @override
  void onEvent(AnalysisEvent event) {
    super.onEvent(event);
    log("AnalysisEvent dispatched: $event");
  }

  Future<void> _onSubscribe(
    SubscribeAnalysisData event,
    Emitter<AnalysisState> emit,
  ) async {
    if (_analysisSubscription == null) {
      emit(state.copyWith(status: AnalysisStatus.loading, transactions: []));
      _analysisSubscription = _analysisRepo
          .getTransactionsPerYear(
              budgetId: event.budgetId, year: state.date.year.toString())
          .listen((event) {
        event.fold(
          (failure) => add(Error(error: failure)),
          (transactions) => add(SubscribedAnalysis(transactions: transactions)),
        );
      });
    }
  }

  Future<void> _onUpdateDate(
    UpdateDate event,
    Emitter<AnalysisState> emit,
  ) async {
    // Handle year filter separately, else just update date and filter transactions
    if (state.filter == AnalyticsFilter.year) {
      await _subscribeToYearData(event.budgetId, event.date.year.toString());
      emit(state.copyWith(
        status: AnalysisStatus.loading,
        date: event.date,
        weekNumber: event.weekNumber,
      ));
    } else {
      emit(state.copyWith(
        date: event.date,
        transactions: _filterTransactions(
          state.filter,
          event.date,
          event.weekNumber,
        ),
      ));
    }
  }

  Future<void> _subscribeToYearData(String budgetId, String year) async {
    await _analysisSubscription?.cancel();

    _analysisSubscription = _analysisRepo
        .getTransactionsPerYear(budgetId: budgetId, year: year)
        .listen((event) {
      event.fold(
        (failure) => add(Error(error: failure)),
        (transactions) => add(SubscribedAnalysis(transactions: transactions)),
      );
    });
  }

  Future<void> _onUpdateFilter(
    UpdateAnalysisFilter event,
    Emitter<AnalysisState> emit,
  ) async {
    emit(state.copyWith(
      transactions: _filterTransactions(event.analyticsFilter, state.date, 1),
      filter: event.analyticsFilter,
    ));
  }

  Future<void> _onSubscribed(
    SubscribedAnalysis event,
    Emitter<AnalysisState> emit,
  ) async {
    _transactions =
        event.transactions; // Update transactions with the latest data
    emit(state.copyWith(
      status: AnalysisStatus.loaded,
      transactions: _filterTransactions(
        state.filter,
        state.date,
        state.weekNumber,
      ),
    ));
  }

  Future<void> _onError(Error event, Emitter<AnalysisState> emit) async {
    await _analysisSubscription!.cancel();
    emit(state.copyWith(error: event.error));
  }

  List<TransactionModel> _filterTransactions(
    AnalyticsFilter filter,
    DateTime date,
    int week,
  ) {
    switch (filter) {
      case AnalyticsFilter.week:
        return _filterTransactionsByWeek(date, week);
      case AnalyticsFilter.month:
        return _filterTransactionsByMonth(date);
      case AnalyticsFilter.year:
        return _filterTransactionsByYear(date);
    }
  }

  List<TransactionModel> _filterTransactionsByWeek(DateTime date, int week) {
    final startDate =
        AnalysisHelper.getStartOfWeek(date.year, date.month, week);
    final endDate = AnalysisHelper.getEndOfWeek(date.year, date.month, week);

    return _transactions.where((transaction) {
      return transaction.date
              .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          transaction.date.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList();
  }

  List<TransactionModel> _filterTransactionsByMonth(DateTime date) {
    return _transactions.where((transaction) {
      return transaction.date.year == date.year &&
          transaction.date.month == date.month;
    }).toList();
  }

  List<TransactionModel> _filterTransactionsByYear(DateTime date) {
    return _transactions.where((transaction) {
      return transaction.date.year == date.year;
    }).toList();
  }
}
