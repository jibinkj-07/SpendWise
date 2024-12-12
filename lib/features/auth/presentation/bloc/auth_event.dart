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

class UpdateUser extends AuthEvent {
  final String? name;
  final String? selectedBudget;
  final String? profile;

  const UpdateUser({
    this.name,
    this.selectedBudget,
    this.profile,
  });

  @override
  List<Object?> get props => [name, selectedBudget, profile];
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
