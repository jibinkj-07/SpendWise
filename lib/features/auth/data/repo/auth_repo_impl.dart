import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:spend_wise/core/util/error/failure.dart';
import 'package:spend_wise/features/auth/data/data_source/auth_fb_data_source.dart';
import 'package:spend_wise/features/auth/domain/model/user_model.dart';
import 'package:spend_wise/features/auth/domain/repo/auth_repo.dart';

import '../../domain/model/settings_model.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthFbDataSource _authFbDataSource;

  AuthRepoImpl(this._authFbDataSource);

  @override
  Future<Either<Failure, void>> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.createUser(
        name: name,
        email: email,
        password: password,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, void>> loginUser({
    required String email,
    required String password,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.loginUser(
        email: email,
        password: password,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, void>> loginUserWithGoogle() async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.loginUserWithGoogle();
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.resetPassword(email: email);
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Stream<Either<Failure, MapEntry<UserModel, SettingsModel>>> subscribeUserData() async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _authFbDataSource.subscribeUserData();
    } else {
      yield Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.signOut();
    } else {
      return Left(NetworkError());
    }
  }
}
