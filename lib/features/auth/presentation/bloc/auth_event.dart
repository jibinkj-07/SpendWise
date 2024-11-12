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

  const LoginUser({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginUserWithGoogle extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class CreateUser extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const CreateUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, password];
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class SignOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}
