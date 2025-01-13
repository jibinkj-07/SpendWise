part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();
}

final class AccountInitial extends AccountState {
  @override
  List<Object> get props => [];
}

final class UpdatingProfileImage extends AccountState {
  @override
  List<Object?> get props => [];
}

final class UpdatedProfileImage extends AccountState {
  @override
  List<Object?> get props => [];
}

final class AccountStateError extends AccountState {
  final Failure error;

  const AccountStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
