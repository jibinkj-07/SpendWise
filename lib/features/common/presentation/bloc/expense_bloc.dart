import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_budget/core/util/error/failure.dart';
import 'package:my_budget/features/common/domain/repo/expense_repo.dart';

import '../../data/model/expense_model.dart';
import '../../data/model/user_model.dart';

part 'expense_event.dart';

part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo _expenseRepo;

  ExpenseBloc(this._expenseRepo) : super(ExpenseState.initial()) {
    on<ExpenseEvent>((event, emit) async {
      switch (event) {
        case GetAllExpense():
          await _getAllExpense(event, emit);
          break;
        case AddExpense():
          await _addExpense(event, emit);
          break;
        case DeleteExpense():
          await _deleteExpense(event, emit);
          break;
        case UpdateDate():
          await _updateDate(event, emit);
          break;
        case UpdateFilter():
          await _updateFilter(event, emit);
          break;
      }
    });
  }

  Future<void> _getAllExpense(
      GetAllExpense event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(expenseStatus: ExpenseStatus.loading));
    try {
      final result = await _expenseRepo.getAllExpense(
        adminId: event.adminId,
        date: state.selectedDate,
      );
      if (result.isRight) {
        emit(
          state.copyWith(
            expenseStatus: ExpenseStatus.idle,
            expenseList: _sortList(result.right, state.expenseFilter),
            error: null,
          ),
        );
      } else {
        emit(ExpenseState.error(result.left, existingDate: state.selectedDate));
      }
    } catch (e) {
      log("er[_getAllExpense][expense_bloc.dart] $e");
      emit(
        ExpenseState.error(
          Failure(message: "An unexpected error occurred"),
          existingDate: state.selectedDate,
        ),
      );
    }
  }

  Future<void> _updateDate(UpdateDate event, Emitter<ExpenseState> emit) async {
    try {
      emit(state.copyWith(selectedDate: event.date));
      add(GetAllExpense(adminId: event.adminId));
    } catch (e) {
      log("er[_updateDate][expense_bloc.dart] $e");
      emit(
        ExpenseState.error(
          Failure(message: "An unexpected error occurred"),
          existingDate: state.selectedDate,
        ),
      );
    }
  }

  Future<void> _addExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(expenseStatus: ExpenseStatus.adding));
    try {
      final result = await _expenseRepo.addExpense(
        expenseModel: event.expenseModel,
        user: event.user,
        documents: event.documents,
      );
      if (result.isRight) {
        final updatedList = List<ExpenseModel>.from(state.expenseList)
          ..add(result.right);
        emit(
          state.copyWith(
            expenseStatus: ExpenseStatus.added,
            expenseList: _sortList(updatedList, state.expenseFilter),
            error: null,
          ),
        );
      } else {
        emit(ExpenseState.error(result.left, existingDate: state.selectedDate));
      }
    } catch (e) {
      log("er[_addExpense][expense_bloc.dart] $e");
      emit(state.copyWith(
        error: Failure(message: "An unexpected error occurred"),
      ));
    }
  }

  Future<void> _deleteExpense(
      DeleteExpense event, Emitter<ExpenseState> emit) async {
    emit(state.copyWith(expenseStatus: ExpenseStatus.deleting));
    try {
      final result = await _expenseRepo.deleteExpense(
        adminId: event.adminId,
        expense: event.expense,
      );
      if (result.isRight) {
        final updatedList = List<ExpenseModel>.from(state.expenseList)
          ..removeWhere((item) => item.id == event.expense.id);
        emit(
          state.copyWith(
            expenseStatus: ExpenseStatus.deleted,
            expenseList: _sortList(updatedList, state.expenseFilter),
            error: null,
          ),
        );
      } else {
        emit(ExpenseState.error(result.left, existingDate: state.selectedDate));
      }
    } catch (e) {
      log("er[_deleteExpense][expense_bloc.dart] $e");
      emit(state.copyWith(
        error: Failure(message: "An unexpected error occurred"),
      ));
    }
  }

  Future<void> _updateFilter(
      UpdateFilter event, Emitter<ExpenseState> emit) async {
    try {
      emit(
        state.copyWith(
          expenseList: _sortList(state.expenseList, event.expenseFilter),
          expenseFilter: event.expenseFilter,
        ),
      );
    } catch (e) {
      log("er[_updateFilter][expense_bloc.dart] $e");
      emit(
        state.copyWith(
          error: Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  List<ExpenseModel> _sortList(List<ExpenseModel> list, ExpenseFilter filter) {
    switch (filter) {
      case ExpenseFilter.ascending:
        {
          list.sort((a, b) => a.date.compareTo(b.date));
          return List.from(list);
        }
      case ExpenseFilter.descending:
        {
          list.sort((a, b) => b.date.compareTo(a.date));
          return List.from(list);
        }
      case ExpenseFilter.most:
        {
          list.sort((a, b) => b.amount.compareTo(a.amount));
          return List.from(list);
        }
      case ExpenseFilter.least:
        {
          list.sort((a, b) => a.amount.compareTo(b.amount));
          return List.from(list);
        }
    }
  }

  @override
  void onEvent(ExpenseEvent event) {
    super.onEvent(event);
    log("ExpenseEvent dispatched: $event");
  }
}
