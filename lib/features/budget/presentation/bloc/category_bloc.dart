import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/category_model.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final FirebaseDatabase _firebaseDatabase;

  StreamSubscription? _categorySubscription;

  CategoryBloc(this._firebaseDatabase) : super(CategoryState.initial()) {
    on<FetchCategory>(_onFetchCategory);
    on<CategoryLoaded>(_onCategoryLoaded);
    on<ThrownError>(_onError);
  }

  Future<void> _onFetchCategory(
    FetchCategory event,
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
                      "An error occurred while processing the budget data.",
                ),
              ),
            );
          }
        } else {
          add(
            ThrownError(
              error: Failure(message: "Unable to retrieve category details"),
            ),
          );
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
