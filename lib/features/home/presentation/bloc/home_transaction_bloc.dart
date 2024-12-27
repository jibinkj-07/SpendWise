import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../budget/domain/repo/budget_repo.dart';

part 'home_transaction_event.dart';

part 'home_transaction_state.dart';

class HomeTransactionBloc
    extends Bloc<HomeTransactionEvent, HomeTransactionState> {
  final FirebaseDatabase _firebaseDatabase;

  final BudgetRepo _budgetRepo;
  StreamSubscription? _transactionSubscription;

  HomeTransactionBloc(this._firebaseDatabase, this._budgetRepo)
      : super(HomeTransactionState.initial()) {
    on<SubscribeTransaction>(_onSubscribeTransaction);
    on<TransactionLoaded>(_onTransactionLoaded);
    on<ThrownError>(_onError);
    on<InsertTransaction>(_onInsert);
    on<RemoveTransaction>(_onRemove);
  }

  Future<void> _onSubscribeTransaction(
    SubscribeTransaction event,
    Emitter<HomeTransactionState> emit,
  ) async {
    final date = DateTime.now();
    // Cancel any previous subscription to avoid multiple listeners
    await _transactionSubscription?.cancel();

    // Set loading state
    emit(state.copyWith(status: HomeTransactionStatus.loading));

    // Calculate start and end timestamps for the month
    final startOfMonth =
        DateTime(date.year, date.month, 1).millisecondsSinceEpoch;
    final endOfMonth = DateTime(date.year, date.month + 1, 0)
        .subtract(Duration(milliseconds: 1))
        .millisecondsSinceEpoch;

    // Start listening to the budget node
    _transactionSubscription = _firebaseDatabase
        .ref(FirebasePath.transactionPath(event.budgetId))
        .orderByChild('date')
        .startAt(startOfMonth)
        .endAt(endOfMonth)
        .onValue
        .listen(
      (snapshotEvent) {
        if (snapshotEvent.snapshot.exists) {
          try {
            final transactions = snapshotEvent.snapshot.children
                .map(
                    (transaction) => TransactionModel.fromFirebase(transaction))
                .toList();

            add(TransactionLoaded(transactions: transactions));
          } catch (e) {
            add(
              ThrownError(
                error: Failure(
                  message:
                      "An error occurred while processing the transaction data.",
                ),
              ),
            );
          }
        } else {
          add(TransactionLoaded(transactions: []));
        }
      },
      onError: (error) {
        add(
          ThrownError(
            error: Failure(
              message: "Failed to listen to transaction data. Error: $error",
            ),
          ),
        );
      },
    );
  }

  Future<void> _onTransactionLoaded(
    TransactionLoaded event,
    Emitter<HomeTransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: HomeTransactionStatus.idle,
        transactions: event.transactions,
      ),
    );
  }

  Future<void> _onInsert(
    InsertTransaction event,
    Emitter<HomeTransactionState> emit,
  ) async {
    emit(state.copyWith(status: HomeTransactionStatus.inserting));
    try {
      final result = await _budgetRepo.insertTransaction(
        budgetId: event.budgetId,
        transaction: event.transaction,
        doc: event.doc,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: HomeTransactionStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: HomeTransactionStatus.inserted)),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: HomeTransactionStatus.idle,
            error: Failure(message: "Unable to create transaction!")),
      );
    }
  }

  Future<void> _onRemove(
    RemoveTransaction event,
    Emitter<HomeTransactionState> emit,
  ) async {
    emit(state.copyWith(status: HomeTransactionStatus.removing));
    try {
      final result = await _budgetRepo.removeTransaction(
        transactionId: event.transactionId,
        budgetId: event.budgetId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: HomeTransactionStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: HomeTransactionStatus.removed)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeTransactionStatus.idle,
          error: Failure(message: "Unable to remove transaction!"),
        ),
      );
    }
  }

  Future<void> _onError(
    ThrownError event,
    Emitter<HomeTransactionState> emit,
  ) async {
    emit(HomeTransactionState.error(event.error));
  }

  @override
  void onEvent(HomeTransactionEvent event) {
    super.onEvent(event);
    log("HomeTransactionEvent dispatched: $event");
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}
