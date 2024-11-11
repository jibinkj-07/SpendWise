import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repo/auth_repo.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(const AuthState.initial()) {
    // Initializing user
    on<InitUser>((event, emit) async {
      emit(
        AuthState.initial().copyWith(
          authStatus: AuthStatus.loading,
        ),
      );
      final result = await _authRepo.initUser();
      if (result.isRight) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.idle,
            currentUser: result.right,
            error: null,
          ),
        );
      } else {
        emit(AuthState.error(result.left));
      }
    });

    // Creating user
    on<CreateUser>((event, emit) async {
      emit(AuthState.initial().copyWith(authStatus: AuthStatus.creating));
      final result = await _authRepo.createUser(
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        password: event.password,
      );
      if (result.isRight) {
        emit(
          state.copyWith(
            currentUser: result.right,
            authStatus: AuthStatus.created,
            error: null,
          ),
        );
      } else {
        emit(AuthState.error(result.left));
      }
    });

    // Logging user
    on<LoginUser>((event, emit) async {
      emit(AuthState.initial().copyWith(authStatus: AuthStatus.logging));
      final result = await _authRepo.loginUser(
        email: event.email,
        password: event.password,
      );
      if (result.isRight) {
        emit(
          state.copyWith(
            currentUser: result.right,
            authStatus: AuthStatus.loggedIn,
            error: null,
          ),
        );
      } else {
        emit(AuthState.error(result.left));
      }
    });

    // Logging user with google
    on<LoginUserWithGoogle>((event, emit) async {
      emit(AuthState.initial().copyWith(authStatus: AuthStatus.logging));
      final result = await _authRepo.loginUserWithGoogle();
      if (result.isRight) {
        emit(
          state.copyWith(
            currentUser: result.right,
            authStatus: AuthStatus.loggedIn,
            error: null,
          ),
        );
      } else {
        emit(AuthState.error(result.left));
      }
    });
    // Resetting password
    on<ResetPassword>((event, emit) async {
      emit(AuthState.initial().copyWith(authStatus: AuthStatus.resetting));
      final result = await _authRepo.resetPassword(email: event.email);
      if (result.isRight) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.reset,
            error: null,
          ),
        );
      } else {
        emit(AuthState.error(result.left));
      }
    });
  }
}
