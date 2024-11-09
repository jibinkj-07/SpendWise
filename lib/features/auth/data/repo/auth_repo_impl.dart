import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:spend_wise/core/util/error/failure.dart';
import 'package:spend_wise/features/auth/data/data_source/auth_fb_data_source.dart';
import 'package:spend_wise/features/auth/domain/model/user_model.dart';
import 'package:spend_wise/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthFbDataSource _authFbDataSource;

  AuthRepoImpl(this._authFbDataSource);

  @override
  Future<Either<Failure, UserModel>> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.loginUser(
        email: email,
        password: password,
      );
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUserWithGoogle() async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.loginUserWithGoogle();
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.resetPassword(email: email);
    } else {
      return Left(Failure.network());
    }
  }

  @override
  Future<Either<Failure, UserModel>> initUser() async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.initUser();
    } else {
      return Left(Failure.network());
    }
  }
}
