import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'budget_edit_event.dart';

part 'budget_edit_state.dart';

class BudgetEditBloc extends Bloc<BudgetEditEvent, BudgetEditState> {
  final BudgetRepo _budgetRepo;

  BudgetEditBloc(this._budgetRepo) : super(IdleBudgetState()) {
    on<AddBudget>(_onAdd);
    on<DeleteBudget>(_onDelete);
  }

  @override
  void onEvent(BudgetEditEvent event) {
    super.onEvent(event);
    log("BudgetEditEvent dispatched: $event");
  }

  Future<void> _onAdd(
    AddBudget event,
    Emitter<BudgetEditState> emit,
  ) async {
    emit(AddingBudget());
    await _budgetRepo
        .addBudget(
          name: event.name,
          admin: event.admin,
          currency: event.currency,
          categories: event.categories,
          members: event.members,
        )
        .fold(
          (failure) => emit(BudgetErrorOccurred(error: failure)),
          (_) => emit(BudgetAdded()),
        );

    await Future.delayed(Duration(seconds: 1), () => emit(IdleBudgetState()));
  }

  Future<void> _onDelete(
    DeleteBudget event,
    Emitter<BudgetEditState> emit,
  ) async {
    emit(DeletingBudget());
    await _budgetRepo.deleteBudget(budgetId: event.budgetId).fold(
          (failure) => emit(BudgetErrorOccurred(error: failure)),
          (_) => emit(BudgetDeleted()),
        );
    await Future.delayed(Duration(seconds: 2), () => emit(IdleBudgetState()));
  }
}
