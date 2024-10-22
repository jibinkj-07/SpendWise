import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_budget/features/common/domain/repo/category_repo.dart';

import '../../../../core/util/error/failure.dart';
import '../../data/model/category_model.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepo _categoryRepo;

  CategoryBloc(this._categoryRepo) : super(const CategoryState.initial()) {
    on<CategoryEvent>((event, emit) async {
      switch (event) {
        case GetAllCategory():
          await _getAllCategory(event, emit);
          break;
        case AddCategory():
          await _addCategory(event, emit);
          break;
        case DeleteCategory():
          await _deleteCategory(event, emit);
          break;
      }
    });
  }

  Future<void> _getAllCategory(
      GetAllCategory event, Emitter<CategoryState> emit) async {
    emit(const CategoryState.initial()
        .copyWith(categoryStatus: CategoryStatus.loading));
    try {
      final result = await _categoryRepo.getAllCategory(adminId: event.adminId);
      if (result.isRight) {
        emit(
          state.copyWith(
            categoryStatus: CategoryStatus.idle,
            categoryList: result.right,
            error: null,
          ),
        );
      } else {
        emit(CategoryState.error(result.left));
      }
    } catch (e) {
      log("er[_getAllCategory][category_bloc.dart] $e");
      emit(
        CategoryState.error(Failure(message: "An unexpected error occurred")),
      );
    }
  }

  Future<void> _addCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(categoryStatus: CategoryStatus.adding));
    // Checking if already category match existing category items
    final index = state.categoryList.indexWhere((item) =>
        item.title.toLowerCase() == event.categoryModel.title.toLowerCase());
    if (index > -1) {
      emit(
        state.copyWith(
          error: Failure(message: "Category already exist"),
          categoryStatus: CategoryStatus.idle,
        ),
      );
      return;
    } else {
      try {
        final result = await _categoryRepo.addCategory(
          categoryModel: event.categoryModel,
          adminId: event.adminId,
        );
        if (result.isRight) {
          final updatedList = List<CategoryModel>.from(state.categoryList)
            ..add(result.right);
          emit(
            state.copyWith(
              categoryStatus: CategoryStatus.added,
              categoryList: updatedList,
              error: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              categoryStatus: CategoryStatus.idle,
              error: result.left,
            ),
          );
        }
      } catch (e) {
        log("er[_addCategory][category_bloc.dart] $e");
        emit(
          state.copyWith(
            categoryStatus: CategoryStatus.idle,
            error: Failure(message: "An unexpected error occurred"),
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(categoryStatus: CategoryStatus.deleting));
    try {
      final result = await _categoryRepo.deleteCategory(
        adminId: event.adminId,
        categoryId: event.categoryId,
      );
      if (result.isRight) {
        final updatedList = List<CategoryModel>.from(state.categoryList)
          ..removeWhere((item) => item.id == event.categoryId);
        emit(
          state.copyWith(
            categoryStatus: CategoryStatus.deleted,
            categoryList: updatedList,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            categoryStatus: CategoryStatus.idle,
            error: result.left,
          ),
        );
      }
    } catch (e) {
      log("er[_deleteCategory][category_bloc.dart] $e");
      emit(
        state.copyWith(
          categoryStatus: CategoryStatus.idle,
          error: Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  @override
  void onEvent(CategoryEvent event) {
    super.onEvent(event);
    log("CategoryEvent dispatched: $event");
  }
}
