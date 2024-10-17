part of 'auth_bloc.dart';

enum AuthStatus { idle,gettingUserInfo, loggingIn, creating,resetting,resetInstructionSent, signingOut }

class AuthState extends Equatable {
  final UserModel? userInfo;
  final AuthStatus authStatus;
  final Failure? error;

  const AuthState._({
    this.authStatus = AuthStatus.idle,
    this.userInfo,
    this.error,
  });

  const AuthState.initial() : this._();

  const AuthState.error(Failure message) : this._(error: message);

  AuthState copyWith({
    UserModel? userInfo,
    AuthStatus? authStatus,
    Failure? error,
  }) =>
      AuthState._(
        userInfo: userInfo ?? this.userInfo,
        authStatus: authStatus ?? this.authStatus,
        error: error,
      );

  @override
  List<Object?> get props => [
        userInfo,
        authStatus,
        error,
      ];
}
