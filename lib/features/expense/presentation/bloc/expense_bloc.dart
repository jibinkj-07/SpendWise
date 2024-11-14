import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/expense_model.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/expense_repo.dart';

part 'expense_event.dart';

part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo _expenseRepo;
  final FirebaseDatabase _firebaseDatabase;

  StreamSubscription? _subscription;

  ExpenseBloc(this._expenseRepo, this._firebaseDatabase)
      : super(const ExpenseState.initial()) {
    // Subscribing to firebase db to retrieve expense data
    void subscribeExpenseData(String expenseId) {
      _subscription = _firebaseDatabase
          .ref(FirebasePath.expensePath(expenseId))
          .onValue
          .listen(
        (DatabaseEvent event) {
          if (event.snapshot.exists) {
            add(
              UpdateExpenseData(
                expense: ExpenseModel.fromFirebase(event.snapshot),
              ),
            );
          }
        },
      );
    }

    on<SubscribeExpenseData>((event, emit) {
      subscribeExpenseData(event.expenseId);
    });

    on<UpdateExpenseData>((event, emit) {
      emit(
        state.copyWith(
          currentExpense: event.expense,
          expenseStatus: ExpenseStatus.idle,
        ),
      );
    });

    /// Category
    on<InsertCategory>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.categoryCreating));
      final result = await _expenseRepo.insertCategory(
        expenseId: event.expenseId,
        category: event.category,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.categoryCreated),
        ),
      );
    });
    on<DeleteCategory>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.categoryDeleting));
      final result = await _expenseRepo.removeCategory(
        expenseId: event.expenseId,
        categoryId: event.categoryId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.categoryDeleted),
        ),
      );
    });

    /// Transaction
    on<InsertTransaction>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.transactionCreating));
      final result = await _expenseRepo.insertTransaction(
        expenseId: event.expenseId,
        transaction: event.transaction,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.transactionCreated),
        ),
      );
    });
    on<DeleteTransaction>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.transactionDeleting));
      final result = await _expenseRepo.removeTransaction(
        expenseId: event.expenseId,
        transactionId: event.transactionId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.transactionDeleted),
        ),
      );
    });

    /// Expense
    on<InsertExpense>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.expenseCreating));
      final result = await _expenseRepo.insertExpense(
        expense: event.expense,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.expenseCreated),
        ),
      );
    });
    on<DeleteExpense>((event, emit) async {
      emit(state.copyWith(expenseStatus: ExpenseStatus.expenseDeleting));
      final result = await _expenseRepo.removeExpense(
        expenseId: event.expenseId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) => emit(
          state.copyWith(expenseStatus: ExpenseStatus.expenseDeleted),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    if (_subscription != null) {
      _subscription?.cancel();
    }
    return super.close();
  }

  @override
  void onEvent(ExpenseEvent event) {
    super.onEvent(event);
    log("ExpenseEvent dispatched: $event");
  }
}
