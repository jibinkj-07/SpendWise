part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();
}

final class UpdateProfileImage extends AccountEvent {
  final String userId;
  final String profileName;

  const UpdateProfileImage({
    required this.userId,
    required this.profileName,
  });

  @override
  List<Object?> get props => [userId, profileName];
}

final class InviteMember extends AccountEvent {
  final String memberId;
  final String budgetId;
  final String budgetName;

  const InviteMember({
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [memberId, budgetId];
}

final class DeleteMember extends AccountEvent {
  final String memberId;
  final String budgetId;
  final String budgetName;

  const DeleteMember({
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [memberId, budgetId];
}
