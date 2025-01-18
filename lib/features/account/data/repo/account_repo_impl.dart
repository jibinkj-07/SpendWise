import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/user.dart';
import '../../domain/repo/account_repo.dart';
import '../data_source/account_fb_data_source.dart';

class AccountRepoImpl implements AccountRepo {
  final AccountFbDataSource _accountFbDataSource;

  AccountRepoImpl(this._accountFbDataSource);

  @override
  Future<Either<Failure, User>> getUserInfoByID({required String id}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.getUserInfoByID(id: id);
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, User>> getUserInfoByMail({
    required String email,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.getUserInfoByMail(email: email);
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.updateSelectedBudget(
        id: id,
        budgetId: budgetId,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserImage({
    required String userId,
    required String profileName,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.updateUserImage(
          userId: userId, profileName: profileName);
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.deleteMember(
        memberId: memberId,
        budgetId: budgetId,
        budgetName: budgetName,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> inviteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _accountFbDataSource.inviteMember(
        memberId: memberId,
        budgetId: budgetId,
        budgetName: budgetName,
      );
    } else {
      return Left(NetworkError());
    }
  }
}
