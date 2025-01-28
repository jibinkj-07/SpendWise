import 'dart:async';
import 'dart:developer';

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
    on<RequestAccess>(_onRequest);
    on<AcceptAccess>(_onAccept);
    on<DeleteMember>(_onDelete);
    on<AcceptBudgetRequest>(_onAcceptBudget);
    on<RemoveBudgetRequest>(_onRemoveBudgetReq);
    on<RemoveMyBudgetRequest>(_onRemoveMyBudgetReq);
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
    emit(Deleting());
    await _accountRepo
        .deleteMember(
            memberId: event.memberId,
            budgetId: event.budgetId,
            fromRequest: event.fromRequest,
            budgetName: event.budgetName)
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(Deleted()));

    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onRequest(
      RequestAccess event, Emitter<AccountState> emit) async {
    emit(Requesting());
    await _accountRepo
        .requestBudgetJoin(
          memberId: event.memberId,
          budgetId: event.budgetId,
          memberName: event.memberName,
        )
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(Requested()));
    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onAccept(
    AcceptAccess event,
    Emitter<AccountState> emit,
  ) async {
    emit(Accepting());
    await _accountRepo
        .acceptMemberRequest(
          memberId: event.memberId,
          budgetId: event.budgetId,
          budgetName: event.budgetName,
        )
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(Accepted()));
    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onAcceptBudget(
    AcceptBudgetRequest event,
    Emitter<AccountState> emit,
  ) async {
    emit(Accepting());
    await _accountRepo
        .acceptBudgetInvitation(
          budgetId: event.budgetId,
          budgetName: event.budgetName,
          userId: event.userId,
          userName: event.userName,
        )
        .fold(
          (error) => emit(AccountStateError(error: error)),
          (_) => emit(Accepted(budgetId: event.budgetId)),
        );

    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onRemoveBudgetReq(
    RemoveBudgetRequest event,
    Emitter<AccountState> emit,
  ) async {
    emit(Deleting());
    await _accountRepo
        .removeBudgetInvitation(
            budgetId: event.budgetId,
            budgetName: event.budgetName,
            userId: event.userId,
            userName: event.userName)
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(Deleted()));
    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  Future<void> _onRemoveMyBudgetReq(
    RemoveMyBudgetRequest event,
    Emitter<AccountState> emit,
  ) async {
    emit(Deleting());
    await _accountRepo
        .removeMyBudgetJoinRequest(
          budgetId: event.budgetId,
          userId: event.userId,
        )
        .fold((error) => emit(AccountStateError(error: error)),
            (success) => emit(Deleted()));
    await Future.delayed(
        const Duration(seconds: 2), () => emit(AccountInitial()));
  }

  @override
  void onEvent(AccountEvent event) {
    super.onEvent(event);
    log("AccountEvent dispatched: $event");
  }
}
