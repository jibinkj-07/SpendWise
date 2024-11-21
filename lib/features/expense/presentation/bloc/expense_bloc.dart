import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../account/domain/model/user.dart';
import '../../../account/presentation/helper/account_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/expense_model.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/expense_repo.dart';

part 'expense_event.dart';

part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo _expenseRepo;
  final FirebaseDatabase _firebaseDatabase;
  final AccountHelper _accountHelper;
  final AuthBloc _authBloc;

  StreamSubscription? _subscription;

  ExpenseBloc(
    this._expenseRepo,
    this._firebaseDatabase,
    this._accountHelper,
    this._authBloc,
  ) : super(const ExpenseState.initial()) {
    // Subscribing to firebase db to retrieve expense data
    void subscribeExpenseData(String expenseId, Emitter<ExpenseState> emit) {
      try {
        _subscription = _firebaseDatabase
            .ref(FirebasePath.expensePath(expenseId))
            .onValue
            .listen(
          (DatabaseEvent event) async {
            if (event.snapshot.exists) {
              List<User> members = [];
              List<User> invited = [];
              for (final member in event.snapshot.child("members").children) {
                final user =
                    await _accountHelper.getUserById(member.key.toString());
                if (user.isRight) {
                  members.add(
                    user.right.copyWith(
                      date: DateTime.fromMillisecondsSinceEpoch(int.parse(event
                          .snapshot
                          .child("members/${member.key}/joined_on")
                          .value
                          .toString())),
                      userStatus: UserStatus.accepted,
                    ),
                  );
                }
              }

              for (final member
                  in event.snapshot.child("invited_users").children) {
                final user =
                    await _accountHelper.getUserById(member.key.toString());
                if (user.isRight) {
                  members.add(
                    user.right.copyWith(
                      date: DateTime.fromMillisecondsSinceEpoch(int.parse(event
                          .snapshot
                          .child("invited_users/${member.key}/invited_on")
                          .value
                          .toString())),
                      userStatus: UserStatus.pending,
                    ),
                  );
                }
              }
              add(
                UpdateExpenseData(
                  expense: ExpenseModel.fromFirebase(
                    event.snapshot,
                    members,
                    invited,
                  ),
                ),
              );
            } else {
              emit(
                ExpenseState.error(Failure(message: "No data found")),
              );
            }
          },
        );
      } catch (e) {
        log("er [expense_bloc.dart][subscribeExpenseData] $e");
      }
    }

    on<SubscribeExpenseData>((event, emit) async {
      final result = await _firebaseDatabase
          .ref(FirebasePath.expensePath(event.expenseId))
          .get();
      if (result.exists) {
        subscribeExpenseData(event.expenseId, emit);
      } else {
        emit(ExpenseState.error(Failure(message: "Data does not exist")));
      }
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
        expenseId: state.currentExpense?.id ?? "unknownExpense",
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
        expenseId: state.currentExpense?.id ?? "unknownExpense",
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
        expenseId: state.currentExpense?.id ?? "unknownExpense",
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
        expenseId: state.currentExpense?.id ?? "unknownExpense",
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
      final result = await _expenseRepo.insertExpense(expense: event.expense);
      result.fold(
        (failure) => emit(
          state.copyWith(
            error: failure,
            expenseStatus: ExpenseStatus.idle,
          ),
        ),
        (user) async {
          _authBloc.add(UpdateUser(currentExpenseId: event.expense.id));
          emit(
            state.copyWith(
              expenseStatus: ExpenseStatus.expenseCreated,
            ),
          );
        },
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
        (user) async {
          emit(
            state.copyWith(expenseStatus: ExpenseStatus.expenseDeleted),
          );
        },
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
