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
