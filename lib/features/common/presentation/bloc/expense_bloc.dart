import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<ExpenseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
