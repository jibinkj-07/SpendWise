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
  }
}
