import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/category_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'category_view_event.dart';

part 'category_view_state.dart';

class CategoryViewBloc extends Bloc<CategoryViewEvent, CategoryViewState> {
  final BudgetRepo _budgetRepo;

  StreamSubscription? _categorySubscription;

  CategoryViewBloc(this._budgetRepo) : super(CategorySubscribing()) {
    on<SubscribeCategory>(_onSubscribe);
    on<CategoryLoaded>(_onLoaded);
    on<CategoryViewErrorOccurred>(_onError);
  }

  @override
  void onEvent(CategoryViewEvent event) {
    super.onEvent(event);
    log("CategoryViewEvent dispatched: $event");
  }

  @override
  Future<void> close() async {
    await _cancelSubscription();
    return super.close();
  }

  Future<void> _onSubscribe(
    SubscribeCategory event,
    Emitter<CategoryViewState> emit,
  ) async {
    await _cancelSubscription();
    emit(CategorySubscribing());
    _categorySubscription =
        _budgetRepo.subscribeCategory(budgetId: event.budgetId).listen((event) {
      if (event.isRight) add(CategoryLoaded(categories: event.right));
      if (event.isLeft) add(CategoryViewErrorOccurred(error: event.left));
    });
  }

  FutureOr<void> _onLoaded(
    CategoryLoaded event,
    Emitter<CategoryViewState> emit,
  ) {
    emit(CategorySubscribed(categories: event.categories));
  }

  FutureOr<void> _onError(
    CategoryViewErrorOccurred event,
    Emitter<CategoryViewState> emit,
  ) {
    emit(CategoryViewError(error: event.error));
  }

  Future<void> _cancelSubscription() async {
    if (_categorySubscription != null) {
      await _categorySubscription!.cancel();
      _categorySubscription = null;
    }
  }
}
