import 'dart:developer';

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
      emit(state.copyWith(authStatus: AuthStatus.loading));
      final result = await _authRepo.initUser();
      result.fold(
        (failure) => emit(AuthState.error(failure)),
        (user) => emit(state.copyWith(
          authStatus: AuthStatus.idle,
          currentUser: user,
        )),
      );
    });

    // Creating user
    on<CreateUser>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.authenticating));
      final result = await _authRepo.createUser(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthState.error(failure)),
        (user) => emit(state.copyWith(
          currentUser: user,
          authStatus: AuthStatus.authenticated,
        )),
      );
    });

    // Logging user
    on<LoginUser>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.authenticating));
      final result = await _authRepo.loginUser(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthState.error(failure)),
        (user) => emit(state.copyWith(
          currentUser: user,
          authStatus: AuthStatus.authenticated,
        )),
      );
    });

    // Logging user with Google
    on<LoginUserWithGoogle>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.authenticating));
      final result = await _authRepo.loginUserWithGoogle();
      result.fold(
        (failure) => emit(AuthState.error(failure)),
        (user) => emit(state.copyWith(
          currentUser: user,
          authStatus: AuthStatus.authenticated,
        )),
      );
    });

    // Resetting password
    on<ResetPassword>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.resetting));
      final result = await _authRepo.resetPassword(email: event.email);
      result.fold(
        (failure) => emit(AuthState.error(failure)),
        (_) => emit(state.copyWith(authStatus: AuthStatus.reset)),
      );
    });

    // Sign Out
    on<SignOut>((event, emit) async {
      emit(state.copyWith(authStatus: AuthStatus.signingOut));
      final result = await _authRepo.signOut();
      result.fold(
        (failure) => emit(state.copyWith(
          authStatus: AuthStatus.idle,
          error: failure,
        )),
        (_) => emit(
            AuthState.initial().copyWith(authStatus: AuthStatus.signedOut)),
      );
    });
  }

  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);
    log("AuthEvent dispatched: $event");
  }
}
