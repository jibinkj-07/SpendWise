part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class SubscribeUserData extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class UserDataLoaded extends AuthEvent {
  final UserModel userData;

  const UserDataLoaded({required this.userData});

  @override
  List<Object?> get props => [userData];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUserWithGoogle extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class CreateUser extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const CreateUser({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthErrorOccurred extends AuthEvent {
  final Failure error;

  const AuthErrorOccurred({required this.error});

  @override
  List<Object?> get props => [error];
}

class SignOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}
