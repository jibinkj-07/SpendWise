import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/transaction_repo.dart';

part 'transaction_edit_event.dart';

part 'transaction_edit_state.dart';

class TransactionEditBloc
    extends Bloc<TransactionEditEvent, TransactionEditState> {
  final TransactionRepo _transactionRepo;

  TransactionEditBloc(this._transactionRepo) : super(IdleTransactionState()) {
    on<AddTransaction>(_onAdd);
    on<UpdateTransaction>(_onUpdate);
    on<DeleteTransaction>(_onDelete);
  }

  @override
  void onEvent(TransactionEditEvent event) {
    super.onEvent(event);
    log("TransactionEditEvent dispatched: $event");
  }

  Future<void> _onAdd(
    AddTransaction event,
    Emitter<TransactionEditState> emit,
  ) async {
    emit(AddingTransaction());
    await _transactionRepo
        .addTransaction(
          budgetId: event.budgetId,
          transaction: event.transaction,
          doc: event.doc,
        )
        .fold(
          (error) => emit(TransactionErrorOccurred(error: error)),
          (_) => emit(TransactionAdded()),
        );
    await Future.delayed(
        Duration(seconds: 1), () => emit(IdleTransactionState()));
  }

  Future<void> _onUpdate(
    UpdateTransaction event,
    Emitter<TransactionEditState> emit,
  ) async {
    emit(AddingTransaction());
    await _transactionRepo.deleteTransaction(
      budgetId: event.budgetId,
      transactionId: event.transaction.id,
      transactionDate: event.oldTransactionDate,
    );
    await _transactionRepo
        .addTransaction(
          budgetId: event.budgetId,
          transaction: event.transaction,
          doc: event.doc,
        )
        .fold(
          (error) => emit(TransactionErrorOccurred(error: error)),
          (_) => emit(TransactionAdded()),
        );
    await Future.delayed(
        Duration(seconds: 1), () => emit(IdleTransactionState()));
  }

  Future<void> _onDelete(
    DeleteTransaction event,
    Emitter<TransactionEditState> emit,
  ) async {
    emit(DeletingTransaction());
    await _transactionRepo
        .deleteTransaction(
          budgetId: event.budgetId,
          transactionDate: event.createdDate,
          transactionId: event.transactionId,
        )
        .fold(
          (error) => emit(TransactionErrorOccurred(error: error)),
          (_) => emit(TransactionDeleted()),
        );
    await Future.delayed(
        Duration(seconds: 1), () => emit(IdleTransactionState()));
  }
}
