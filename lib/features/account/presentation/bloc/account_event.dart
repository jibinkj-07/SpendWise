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
  final bool isJoinRequest;

  const DeleteMember({
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
    required this.isJoinRequest,
  });

  @override
  List<Object?> get props => [memberId, budgetId];
}

final class RequestAccess extends AccountEvent {
  final String memberId;
  final String budgetId;
  final String memberName;

  const RequestAccess({
    required this.memberId,
    required this.budgetId,
    required this.memberName,
  });

  @override
  List<Object?> get props => [memberId, budgetId];
}

final class AcceptAccess extends AccountEvent {
  final String memberId;
  final String budgetId;
  final String budgetName;

  const AcceptAccess({
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [memberId, budgetId];
}

final class AcceptBudgetRequest extends AccountEvent {
  final String budgetId;
  final String budgetName;
  final String userId;
  final String userName;

  const AcceptBudgetRequest({
    required this.userId,
    required this.userName,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [userId, budgetId];
}

final class LeaveBudget extends AccountEvent {
  final String budgetId;
  final String budgetName;
  final String userId;
  final String userName;

  const LeaveBudget({
    required this.userId,
    required this.userName,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [userId, budgetId];
}

final class RemoveBudgetRequest extends AccountEvent {
  final String budgetId;
  final String budgetName;
  final String userId;
  final String userName;

  const RemoveBudgetRequest({
    required this.userId,
    required this.userName,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  List<Object?> get props => [userId, budgetId];
}

final class RemoveMyBudgetRequest extends AccountEvent {
  final String budgetId;
  final String userId;

  const RemoveMyBudgetRequest({
    required this.userId,
    required this.budgetId,
  });

  @override
  List<Object?> get props => [userId, budgetId];
}
