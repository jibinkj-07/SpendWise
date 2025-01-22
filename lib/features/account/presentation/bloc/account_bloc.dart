import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/repo/account_repo.dart';

part 'account_event.dart';

part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepo _accountRepo;

  AccountBloc(this._accountRepo) : super(AccountInitial()) {
    on<UpdateProfileImage>(_onUpdate);
    on<InviteMember>(_onInvite);
    on<DeleteMember>(_onDelete);
  }

  Future<void> _onUpdate(
    UpdateProfileImage event,
    Emitter<AccountState> emit,
  ) async {
    emit(UpdatingProfileImage());
    await _accountRepo
        .updateUserImage(userId: event.userId, profileName: event.profileName)
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(UpdatedProfileImage()));

    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onInvite(
    InviteMember event,
    Emitter<AccountState> emit,
  ) async {
    emit(InvitingMember());
    await _accountRepo
        .inviteMember(
            memberId: event.memberId,
            budgetId: event.budgetId,
            budgetName: event.budgetName)
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(InvitedMember()));

    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onDelete(DeleteMember event, Emitter<AccountState> emit) async {
    emit(DeletingMember());
    await _accountRepo
        .deleteMember(
            memberId: event.memberId,
            budgetId: event.budgetId,
            fromRequest: event.fromRequest,
            budgetName: event.budgetName)
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(DeletedMember()));

    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }
}
