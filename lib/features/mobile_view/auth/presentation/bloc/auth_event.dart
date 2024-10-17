part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
}

class InitUser extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class CreateUser extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const CreateUser({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class SignOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}
