import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseDatabase _firebaseDatabase;
  final BudgetRepo _budgetRepo;

  StreamSubscription? _categorySubscription;

  CategoryBloc(this._firebaseDatabase, this._budgetRepo)
      : super(CategoryState.initial()) {
    on<SubscribeCategory>(_onSubscribeCategory);
    on<CategoryLoaded>(_onCategoryLoaded);
    on<ThrownError>(_onError);
    on<InsertCategory>(_onInsert);
    on<RemoveCategory>(_onRemove);
  }

  Future<void> _onSubscribeCategory(
    SubscribeCategory event,
    Emitter<CategoryState> emit,
  ) async {
    // Cancel any previous subscription to avoid multiple listeners
    await _categorySubscription?.cancel();

    // Set loading state
    emit(state.copyWith(status: CategoryStatus.loading));

    // Start listening to the budget node
    _categorySubscription = _firebaseDatabase
        .ref(FirebasePath.budgetPath(event.budgetId))
        .child("categories")
        .onValue
        .listen(
      (snapshotEvent) {
        if (snapshotEvent.snapshot.exists) {
          try {
            final categories = snapshotEvent.snapshot.children
                .map((category) => CategoryModel.fromFirebase(category))
                .toList();

            add(CategoryLoaded(categories: categories));
          } catch (e) {
            add(
              ThrownError(
                error: Failure(
                  message:
                      "An error occurred while processing the category data.",
                ),
              ),
            );
          }
        } else {
          add(CategoryLoaded(categories: []));
        }
      },
      onError: (error) {
        add(
          ThrownError(
            error: Failure(
              message: "Failed to listen to category data. Error: $error",
            ),
          ),
        );
      },
    );
  }

  Future<void> _onCategoryLoaded(
    CategoryLoaded event,
    Emitter<CategoryState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CategoryStatus.idle,
        categories: event.categories,
      ),
    );
  }

  Future<void> _onInsert(
    InsertCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.inserting));
    try {
      final result = await _budgetRepo.insertCategory(
        budgetId: event.budgetId,
        category: event.category,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: CategoryStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: CategoryStatus.inserted)),
      );
    } catch (e) {
      emit(
        state.copyWith(
            status: CategoryStatus.idle,
            error: Failure(message: "Unable to create category!")),
      );
    }
  }

  Future<void> _onRemove(
    RemoveCategory event,
    Emitter<CategoryState> emit,
  ) async {
    emit(state.copyWith(status: CategoryStatus.removing));
    try {
      final result = await _budgetRepo.removeCategory(
        categoryId: event.categoryId,
        budgetId: event.budgetId,
      );
      result.fold(
        (failure) => emit(
          state.copyWith(status: CategoryStatus.idle, error: failure),
        ),
        (_) => emit(state.copyWith(status: CategoryStatus.removed)),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CategoryStatus.idle,
          error: Failure(message: "Unable to remove category!"),
        ),
      );
    }
  }

  Future<void> _onError(
    ThrownError event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryState.error(event.error));
  }

  @override
  void onEvent(CategoryEvent event) {
    super.onEvent(event);
    log("CategoryEvent dispatched: $event");
  }

  @override
  Future<void> close() {
    _categorySubscription?.cancel();
    return super.close();
  }
}
