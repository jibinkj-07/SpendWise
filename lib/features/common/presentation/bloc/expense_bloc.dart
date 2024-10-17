import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_budget/core/util/error/failure.dart';

import '../../data/model/expense_model.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseState.initial()) {
    on<ExpenseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
