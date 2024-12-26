import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseDatabase _firebaseDatabase;

  final BudgetRepo _budgetRepo;
  StreamSubscription? _categorySubscription;

  TransactionBloc(this._firebaseDatabase, this._budgetRepo)
      : super(TransactionState.initial()) {
    on<SubscribeTransaction>(_onSubscribeTransaction);
    on<TransactionLoaded>(_onTransactionLoaded);
    on<ThrownError>(_onError);
    on<InsertTransaction>(_onInsert);
    on<RemoveTransaction>(_onRemove);
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

  Future<void> _onInsert(
    InsertTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.inserting));
    try {
      final result = await _budgetRepo.insertTransaction(
        budgetId: event.budgetId,
        transaction: event.transaction,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: TransactionStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: TransactionStatus.inserted)),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: TransactionStatus.idle,
            error: Failure(message: "Unable to create transaction!")),
      );
    }
  }

  Future<void> _onRemove(
    RemoveTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.removing));
    try {
      final result = await _budgetRepo.removeTransaction(
        transactionId: event.transactionId,
        budgetId: event.budgetId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: TransactionStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: TransactionStatus.removed)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.idle,
          error: Failure(message: "Unable to remove transaction!"),
        ),
      );
    }
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
