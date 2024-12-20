import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/transaction_model.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseDatabase _firebaseDatabase;

  StreamSubscription? _categorySubscription;

  TransactionBloc(this._firebaseDatabase) : super(TransactionState.initial()) {
    on<SubscribeTransaction>(_onSubscribeTransaction);
    on<TransactionLoaded>(_onTransactionLoaded);
    on<ThrownError>(_onError);
  }

  Future<void> _onSubscribeTransaction(
    SubscribeTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    // Cancel any previous subscription to avoid multiple listeners
    await _categorySubscription?.cancel();

    // Set loading state
    emit(state.copyWith(status: TransactionStatus.loading));

    int startTimestamp = event.startDate.millisecondsSinceEpoch;
    int endTimestamp = event.endDate.millisecondsSinceEpoch;

    // Start listening to the budget node
    _categorySubscription = _firebaseDatabase
        .ref(FirebasePath.transactionPath(event.budgetId))
        .orderByChild("date")
        .startAt(startTimestamp)
        .endAt(endTimestamp)
        .onValue
        .listen(
      (snapshotEvent) {
        if (snapshotEvent.snapshot.exists) {
          try {
            final transactions = snapshotEvent.snapshot.children
                .map((category) => TransactionModel.fromFirebase(category))
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
    Emitter<TransactionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TransactionStatus.idle,
        transactions: event.transactions,
      ),
    );
  }

  Future<void> _onError(
    ThrownError event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionState.error(event.error));
  }

  @override
  void onEvent(TransactionEvent event) {
    super.onEvent(event);
    log("TransactionEvent dispatched: $event");
  }

  @override
  Future<void> close() {
    _categorySubscription?.cancel();
    return super.close();
  }
}
