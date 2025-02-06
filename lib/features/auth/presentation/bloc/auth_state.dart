part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {}

class Fetching extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticating extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  final UserModel user;
  final SettingsModel settings;
  final Failure? error;

  Authenticated({
    required this.user,
    required this.settings,
    this.error,
  });

  @override
  List<Object?> get props => [
        user,
        settings,
        error,
      ];
}

class ResetMailSending extends AuthState {
  @override
  List<Object?> get props => [];
}

class ResetMailSent extends AuthState {
  @override
  List<Object?> get props => [];
}

class SigningOut extends AuthState {
  @override
  List<Object?> get props => [];
}

class SignedOut extends AuthState {
  @override
  List<Object?> get props => [];
}

class Logging extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final Failure error;

  AuthError({required this.error});

  @override
  List<Object?> get props => [Error];
}
