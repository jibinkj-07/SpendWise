import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/budget_model.dart';
import '../../domain/repo/budget_repo.dart';

part 'budget_view_event.dart';

part 'budget_view_state.dart';

class BudgetViewBloc extends Bloc<BudgetViewEvent, BudgetViewState> {
  final BudgetRepo _budgetRepo;

  StreamSubscription? _budgetSubscription;

  BudgetViewBloc(this._budgetRepo) : super(BudgetSubscribing()) {
    on<SubscribeBudget>(_onSubscribe);
    on<BudgetLoaded>(_onLoaded);
    on<CancelSubscription>(_onCancel);
    on<BudgetViewErrorOccurred>(_onError);
  }

  @override
  void onEvent(BudgetViewEvent event) {
    super.onEvent(event);
    log("BudgetViewEvent dispatched: $event");
  }

  @override
  Future<void> close() async {
    await _cancelSubscription();
    return super.close();
  }

  Future<void> _onSubscribe(
    SubscribeBudget event,
    Emitter<BudgetViewState> emit,
  ) async {
    await _cancelSubscription();
    emit(BudgetSubscribing());
    _budgetSubscription =
        _budgetRepo.subscribeBudget(budgetId: event.budgetId).listen(
      (event) {
        if (event.isRight) add(BudgetLoaded(budget: event.right));
        if (event.isLeft) add(BudgetViewErrorOccurred(error: event.left));
      },
      onError: (error) {
        add(
          BudgetViewErrorOccurred(
            error: AccessRevokedError(
              message: "An unexpected error occurred\n\n$error",
            ),
          ),
        );
      },
      cancelOnError: true,
    );
  }

  FutureOr<void> _onLoaded(
    BudgetLoaded event,
    Emitter<BudgetViewState> emit,
  ) {
    emit(BudgetSubscribed(budget: event.budget));
  }

  FutureOr<void> _onError(
    BudgetViewErrorOccurred event,
    Emitter<BudgetViewState> emit,
  ) {
    emit(BudgetViewError(error: event.error));
  }

  Future<void> _onCancel(
    CancelSubscription event,
    Emitter<BudgetViewState> emit,
  ) async {
    await _cancelSubscription();
    emit(BudgetSubscribing());
  }

  Future<void> _cancelSubscription() async {
    if (_budgetSubscription != null) {
      await _budgetSubscription!.cancel();
      _budgetSubscription = null;
    }
  }
}
