import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/transaction_repo.dart';

part 'month_trans_view_event.dart';

part 'month_trans_view_state.dart';

class MonthTransViewBloc
    extends Bloc<MonthTransViewEvent, MonthTransViewState> {
  final TransactionRepo _transactionRepo;

  StreamSubscription? _transactionSubscription;

  MonthTransViewBloc(this._transactionRepo)
      : super(SubscribingMonthTransState()) {
    on<SubscribeMonthView>(_onSubscribe);
    on<SubscribedMonthView>(_onSubscribed);
    on<ErrorMonthView>(_onError);
  }

  @override
  void onEvent(MonthTransViewEvent event) {
    super.onEvent(event);
    log("MonthTransViewEvent dispatched: $event");
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }

  Future<void> _onSubscribe(
    SubscribeMonthView event,
    Emitter<MonthTransViewState> emit,
  ) async {
    await _transactionSubscription?.cancel();
    emit(SubscribingMonthTransState());
    _transactionSubscription = _transactionRepo
        .subscribeMonthlyTransactions(
            budgetId: event.budgetId, date: event.date)
        .listen((event) {
      if (event.isRight) add(SubscribedMonthView(transactions: event.right));
      if (event.isLeft) add(ErrorMonthView(error: event.left));
    });
  }

  FutureOr<void> _onSubscribed(
    SubscribedMonthView event,
    Emitter<MonthTransViewState> emit,
  ) {
    emit(SubscribedMonthTransState(transactions: event.transactions));
  }

  FutureOr<void> _onError(
    ErrorMonthView event,
    Emitter<MonthTransViewState> emit,
  ) {
    emit(ErrorOccurredMonthTransState(error: event.error));
  }
}
