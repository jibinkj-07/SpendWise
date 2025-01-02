import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'category_edit_event.dart';

part 'category_edit_state.dart';

class CategoryEditBloc extends Bloc<CategoryEditEvent, CategoryEditState> {
  final BudgetRepo _budgetRepo;

  CategoryEditBloc(this._budgetRepo) : super(IdleCategoryState()) {
    on<AddCategory>(_onAdd);
    on<DeleteCategory>(_onDelete);
  }

  @override
  void onEvent(CategoryEditEvent event) {
    super.onEvent(event);
    log("CategoryEditEvent dispatched: $event");
  }

  Future<void> _onAdd(
    AddCategory event,
    Emitter<CategoryEditState> emit,
  ) async {
    emit(AddingCategory());
    await _budgetRepo
        .addCategory(budgetId: event.budgetId, category: event.category)
        .fold(
          (failure) => emit(CategoryErrorOccurred(error: failure)),
          (_) => emit(CategoryAdded()),
        );
  }

  Future<void> _onDelete(
    DeleteCategory event,
    Emitter<CategoryEditState> emit,
  ) async {
    emit(DeletingCategory());
    await _budgetRepo
        .deleteCategory(
          budgetId: event.budgetId,
          categoryId: event.categoryId,
        )
        .fold(
          (failure) => emit(CategoryErrorOccurred(error: failure)),
          (_) => emit(CategoryDeleted()),
        );
  }
}
