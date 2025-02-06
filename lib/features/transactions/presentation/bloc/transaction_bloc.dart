import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/transaction_repo.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepo _transactionRepo;

  List<TransactionModel> _transactions = [];
  StreamSubscription? _transactionSubscription;

  TransactionBloc(this._transactionRepo) : super(TransactionState.initial()) {
    on<SubscribeTransaction>(_onSubscribe);
    on<SubscribedTransaction>(_onSubscribed);
    on<UpdateCategory>(_onUpdateCategory);
    on<UpdateTransactionDate>(_onUpdateDate);
    on<CancelTransactionSubscription>(_onCancelSubscription);
    on<ErrorTransaction>(_onError);
  }

  @override
  Future<void> close() async {
    await _cancelSubscription();
    return super.close();
  }

  @override
  void onEvent(TransactionEvent event) {
    super.onEvent(event);
    log("TransactionEvent dispatched: $event");
  }

  FutureOr<void> _onSubscribe(
    SubscribeTransaction event,
    Emitter<TransactionState> emit,
  ) {
    if (_transactionSubscription == null) {
      emit(
        state.copyWith(
          status: TransactionStatus.loading,
          transactions: [],
        ),
      );
      _transactionSubscription = _transactionRepo
          .subscribeMonthlyTransactions(
        budgetId: event.budgetId,
        date: state.date,
      )
          .listen(
        (result) {
          result.fold(
            (failure) => add(ErrorTransaction(error: failure)),
            (transactions) => add(SubscribedTransaction(
              transactions: transactions,
              date: state.date,
            )),
          );
        },
        onError: (error) {
          add(
            ErrorTransaction(
              error: AccessRevokedError(
                message: "An unexpected error occurred\n\n$error",
              ),
            ),
          );
        },
        cancelOnError: true,
      );
    }
  }

  FutureOr<void> _onSubscribed(
    SubscribedTransaction event,
    Emitter<TransactionState> emit,
  ) {
    _transactions = event.transactions;
    emit(
      state.copyWith(
        date: event.date,
        status: TransactionStatus.loaded,
        transactions: _filterTransactions(state.selectedCategoryId),
      ),
    );
  }

  FutureOr<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<TransactionState> emit,
  ) {
    final catId =
        state.selectedCategoryId == event.categoryId ? "" : event.categoryId;
    emit(
      state.copyWith(
        transactions: _filterTransactions(catId),
        selectedCategoryId: catId,
      ),
    );
  }

  Future<void> _onUpdateDate(
    UpdateTransactionDate event,
    Emitter<TransactionState> emit,
  ) async {
    await _cancelSubscription();
    _transactions = [];
    emit(
      state.copyWith(
        status: TransactionStatus.loading,
        transactions: [],
      ),
    );
    _transactionSubscription = _transactionRepo
        .subscribeMonthlyTransactions(
      budgetId: event.budgetId,
      date: event.date,
    )
        .listen(
      (result) {
        result.fold(
          (failure) => add(ErrorTransaction(error: failure)),
          (transactions) => add(SubscribedTransaction(
            transactions: transactions,
            date: event.date,
          )),
        );
      },
      onError: (error) {
        add(
          ErrorTransaction(
            error: AccessRevokedError(
              message: "An unexpected error occurred\n\n$error",
            ),
          ),
        );
      },
      cancelOnError: true,
    );
  }

  Future<void> _onCancelSubscription(
    CancelTransactionSubscription event,
    Emitter<TransactionState> emit,
  ) async {
    await _cancelSubscription();
    emit(TransactionState.initial());
  }

  Future<void> _onError(
    ErrorTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    if (_transactionSubscription != null) {
      await _transactionSubscription!.cancel();
    }
    emit(state.copyWith(error: event.error, status: TransactionStatus.loaded));
  }

  List<TransactionModel> _filterTransactions(String categoryId) => categoryId
          .trim()
          .isEmpty
      ? List.from(_transactions)
      : _transactions.where((item) => item.categoryId == categoryId).toList();

  Future<void> _cancelSubscription() async {
    if (_transactionSubscription != null) {
      await _transactionSubscription!.cancel();
      _transactionSubscription = null;
    }
  }
}
