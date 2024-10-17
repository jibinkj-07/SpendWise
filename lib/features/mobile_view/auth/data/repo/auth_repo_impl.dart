import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_budget/core/util/error/failure.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';
import 'package:my_budget/features/mobile_view/auth/data/data_source/auth_fb_data_source.dart';
import 'package:my_budget/features/mobile_view/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthFbDataSource _authFbDataSource;

  AuthRepoImpl(this._authFbDataSource);

  @override
  Future<Either<Failure, UserModel>> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.createAccount(
        email: email,
        password: password,
        name: name,
      );
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserDetail(
      {required String uid}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.getUserDetail(uid: uid);
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.loginUser(
          email: email, password: password);
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.resetPassword(email: email);
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await InternetConnection().hasInternetAccess) {
      return await _authFbDataSource.signOut();
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }
}
