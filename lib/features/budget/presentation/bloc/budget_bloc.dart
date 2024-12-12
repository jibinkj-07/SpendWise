import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/budget_model.dart';
import '../../domain/model/category_model.dart';

part 'budget_event.dart';

part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final FirebaseDatabase _firebaseDatabase;

  StreamSubscription? _budgetSubscription;

  BudgetBloc(this._firebaseDatabase) : super(BudgetState.initial()) {
    on<FetchBudget>(_onFetchBudget);
    on<BudgetLoaded>(_onBudgetLoaded);
    on<ThrownError>(_onError);
  }

  Future<void> _onFetchBudget(
    FetchBudget event,
    Emitter<BudgetState> emit,
  ) async {
    // Cancel any previous subscription to avoid multiple listeners
    await _budgetSubscription?.cancel();

    // Set loading state
    emit(state.copyWith(status: BudgetStatus.loading));

    // Start listening to the budget node
    _budgetSubscription = _firebaseDatabase
        .ref(FirebasePath.budgetDetailPath(event.budgetId))
        .onValue
        .listen(
      (snapshotEvent) {
        if (snapshotEvent.snapshot.exists) {
          try {
            final details = BudgetModel.fromFirebase(
              snapshotEvent.snapshot,
              event.budgetId,
            );
            add(BudgetLoaded(budget: details));
          } catch (e) {
            add(
              ThrownError(
                error: Failure(
                  message:
                      "An error occurred while processing the budget data.",
                ),
              ),
            );
          }
        } else {
          add(
            ThrownError(
              error: Failure(
                message:
                    "Unable to retrieve budget details. The data might have been deleted,"
                    " or you may not have access to this budget."
                    " Please contact the administrator for further assistance.",
              ),
            ),
          );
        }
      },
      onError: (error) {
        add(
          ThrownError(
            error: Failure(
              message: "Failed to listen to budget data. Error: $error",
            ),
          ),
        );
      },
    );
  }

  Future<void> _onBudgetLoaded(
    BudgetLoaded event,
    Emitter<BudgetState> emit,
  ) async {
    emit(
      state.copyWith(status: BudgetStatus.idle, budgetDetail: event.budget),
    );
  }

  Future<void> _onError(
    ThrownError event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetState.error(event.error));
  }

  @override
  void onEvent(BudgetEvent event) {
    super.onEvent(event);
    log("BudgetEvent dispatched: $event");
  }

  @override
  Future<void> close() {
    _budgetSubscription?.cancel();
    return super.close();
  }
}
