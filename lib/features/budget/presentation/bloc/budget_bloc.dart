import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/budget_model.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'budget_event.dart';

part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final FirebaseDatabase _firebaseDatabase;
  final BudgetRepo _budgetRepo;

  StreamSubscription? _budgetSubscription;

  BudgetBloc(this._firebaseDatabase, this._budgetRepo)
      : super(BudgetState.initial()) {
    on<SubscribeBudget>(_onSubscribeBudget);
    on<BudgetLoaded>(_onBudgetLoaded);
    on<ThrownError>(_onError);
    on<InsertBudget>(_onInsert);
    on<RemoveBudget>(_onRemove);
  }

  Future<void> _onSubscribeBudget(
    SubscribeBudget event,
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
      state.copyWith(
        status: BudgetStatus.idle,
        budgetDetail: event.budget,
      ),
    );
  }

  Future<void> _onInsert(
    InsertBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.inserting));
    try {
      final result = await _budgetRepo.insertBudget(
        name: event.name,
        admin: event.admin,
        categories: event.categories,
        currency: event.currency,
        members: event.members,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: BudgetStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: BudgetStatus.inserted)),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: BudgetStatus.idle,
            error: Failure(message: "Unable to create budget!")),
      );
    }
  }

  Future<void> _onRemove(
    RemoveBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.removing));
    try {
      final result = await _budgetRepo.removeBudget(budgetId: event.budgetId);
      result.fold(
        (failure) => emit(
          state.copyWith(status: BudgetStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: BudgetStatus.removed)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BudgetStatus.idle,
          error: Failure(message: "Unable to remove budget!"),
        ),
      );
    }
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
