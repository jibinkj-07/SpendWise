import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/util/error/failure.dart';
import '../../../../common/data/model/user_model.dart';
import '../../domain/repo/auth_repo.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;
  final FirebaseAuth _firebaseAuth;

  AuthBloc(this._authRepo, this._firebaseAuth)
      : super(const AuthState.initial()) {
    on<AuthEvent>(
      (event, emit) async {
        switch (event) {
          case InitUser():
            await _initUser(event, emit);
            break;
          case LoginUser():
            await _loginUser(event, emit);
            break;
          case CreateUser():
            await _createAccount(event, emit);
            break;
          case ResetPassword():
            _resetPassword(event, emit);
            break;
          case SignOut():
            await _signOut(event, emit);
            break;
        }
      },
    );
  }

  Future<void> _initUser(InitUser event, Emitter<AuthState> emit) async {
    emit(const AuthState.initial()
        .copyWith(authStatus: AuthStatus.gettingUserInfo));
    try {
      final uid = _firebaseAuth.currentUser!.uid;
      // Attempt to retrieve user details from remote
      final remoteUser = await _authRepo.getUserDetail(uid: uid);
      if (remoteUser.isRight) {
        emit(
          state.copyWith(
            userInfo: remoteUser.right,
            error: null,
            authStatus: AuthStatus.idle,
          ),
        );
      }
    } catch (e) {
      log("er: [_initUser][auth_bloc.dart] $e");
      emit(
        AuthState.error(Failure(message: "An unexpected error occurred")),
      );
    }
  }

  Future<void> _createAccount(
    CreateUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.initial().copyWith(authStatus: AuthStatus.creating));
    try {
      final result = await _authRepo.createAccount(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      if (result.isLeft) {
        emit(AuthState.error(result.left));
      } else {
        emit(
          state.copyWith(
            userInfo: result.right,
            error: null,
            authStatus: AuthStatus.idle,
          ),
        );
      }
    } catch (e) {
      log("er: [_createAccount][account_bloc.dart] $e");
      emit(
        AuthState.error(
          Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  Future<void> _resetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.initial().copyWith(authStatus: AuthStatus.resetting));
    try {
      final result = await _authRepo.resetPassword(email: event.email);
      if (result.isLeft) {
        emit(AuthState.error(result.left));
      } else {
        emit(state.copyWith(authStatus: AuthStatus.resetInstructionSent));
      }
    } catch (e) {
      log("er: [_resetPassword][account_bloc.dart] $e");
      emit(
        AuthState.error(
          Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  Future<void> _loginUser(LoginUser event, Emitter<AuthState> emit) async {
    // Emit fetching state
    emit(const AuthState.initial().copyWith(authStatus: AuthStatus.loggingIn));
    try {
      // Perform login
      final result = await _authRepo.loginUser(
        email: event.email,
        password: event.password,
      );
      if (result.isLeft) {
        emit(AuthState.error(result.left));
      } else {
        emit(
          state.copyWith(
            userInfo: result.right,
            error: null,
            authStatus: AuthStatus.idle,
          ),
        );
      }
    } catch (e) {
      // Handle any other errors
      log("er: [_loginUser][auth_bloc.dart] $e");
      emit(
        AuthState.error(
          Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  Future<void> _signOut(SignOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(authStatus: AuthStatus.signingOut));
    try {
      final result = await _authRepo.signOut();
      if (result.isLeft) {
        emit(state.copyWith(error: result.left, authStatus: AuthStatus.idle));
      } else {
        emit(const AuthState.initial());
      }
    } catch (e) {
      // Handle any other errors
      log("er: [_signOut][auth_bloc.dart] $e");
      emit(
        AuthState.error(
          Failure(message: "An unexpected error occurred"),
        ),
      );
    }
  }

  @override
  void onEvent(AuthEvent event) {
    super.onEvent(event);
    log("AuthEvent dispatched: $event");
  }
}
