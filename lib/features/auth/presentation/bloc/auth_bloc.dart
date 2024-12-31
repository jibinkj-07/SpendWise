import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/user_model.dart';
import '../../domain/repo/auth_repo.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(Fetching()) {
    on<SubscribeUserData>(_onSubscribe);
    on<UserDataLoaded>(_onDataLoad);
    on<LoginUser>(_onLogin);
    on<LoginUserWithGoogle>(_onLoginWithGoogle);
    on<CreateUser>(_onCreate);
    on<ResetPassword>(_onReset);
    on<SignOut>(_onSignOut);
    on<AuthErrorOccurred>(_onError);
  }

  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);
    log("AuthEvent dispatched: $event");
  }

  FutureOr<void> _onSubscribe(
      SubscribeUserData event, Emitter<AuthState> emit) {
    emit(Fetching());
    _authRepo.subscribeUserData().listen((event) {
      if (event.isRight) add(UserDataLoaded(userData: event.right));
      if (event.isLeft) add(AuthErrorOccurred(error: event.left));
    });
  }

  FutureOr<void> _onDataLoad(UserDataLoaded event, Emitter<AuthState> emit) {
    emit(Authenticated(user: event.userData));
  }

  Future<void> _onLogin(LoginUser event, Emitter<AuthState> emit) async {
    emit(Authenticating());
    await _authRepo
        .loginUser(email: event.email, password: event.password)
        .fold(
          (failure) => emit(AuthError(error: failure)),
          (_) => add(SubscribeUserData()),
        );
  }

  Future<void> _onLoginWithGoogle(
      LoginUserWithGoogle event, Emitter<AuthState> emit) async {
    emit(Authenticating());
    await _authRepo.loginUserWithGoogle().fold(
        (failure) => emit(AuthError(error: failure)),
        (_) => add(SubscribeUserData()));
  }

  Future<void> _onCreate(CreateUser event, Emitter<AuthState> emit) async {
    emit(Authenticating());
    await _authRepo
        .createUser(
          name: event.name,
          email: event.email,
          password: event.password,
        )
        .fold((failure) => emit(AuthError(error: failure)),
            (_) => add(SubscribeUserData()));
  }

  Future<void> _onReset(ResetPassword event, Emitter<AuthState> emit) async {
    emit(ResetMailSending());
    await _authRepo.resetPassword(email: event.email).fold(
          (failure) => emit(AuthError(error: failure)),
          (_) => emit(ResetMailSent()),
        );
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(SigningOut());
    await _authRepo.signOut().fold(
          (failure) => emit(AuthError(error: failure)),
          (_) => emit(SignedOut()),
        );
  }

  FutureOr<void> _onError(AuthErrorOccurred event, Emitter<AuthState> emit) {
    emit(AuthError(error: event.error));
  }
}
