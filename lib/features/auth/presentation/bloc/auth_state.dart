part of 'auth_bloc.dart';

enum AuthStatus {
  idle,
  loading,
  logging,
  loggedIn,
  creating,
  created,
  resetting,
  reset,
  signingOut,
  signedOut,
}

class AuthState extends Equatable {
  final AuthStatus authStatus;
  final UserModel? currentUser;
  final Failure? error;

  const AuthState._({
    this.authStatus = AuthStatus.idle,
    this.currentUser,
    this.error,
  });

  const AuthState.initial() : this._();

  const AuthState.error(Failure message) : this._(error: message);

  AuthState copyWith({
    UserModel? currentUser,
    AuthStatus? authStatus,
    Failure? error,
  }) =>
      AuthState._(
        currentUser: currentUser ?? this.currentUser,
        authStatus: authStatus ?? this.authStatus,
        error: error,
      );

  @override
  List<Object?> get props => [authStatus, currentUser, error];
}
