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

final class InvitingMember extends AccountState {
  @override
  List<Object?> get props => [];
}

final class InvitedMember extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Deleting extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Deleted extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Requesting extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Requested extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Accepting extends AccountState {
  @override
  List<Object?> get props => [];
}

final class Accepted extends AccountState {
  final String budgetId;

  const Accepted({this.budgetId = ""});

  @override
  List<Object?> get props => [budgetId];
}

final class AccountStateError extends AccountState {
  final Failure error;

  const AccountStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
