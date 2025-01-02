import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/user.dart';
import '../../domain/repo/account_repo.dart';

class AccountHelper {
  final AccountRepo _accountRepo;

  AccountHelper(this._accountRepo);

  Future<Either<Failure, User>> getUserInfoByMail({
    required String email,
  }) async =>
      await _accountRepo.getUserInfoByMail(email: email);

  Future<Either<Failure, User>> getUserInfoByID({
    required String id,
  }) async =>
      await _accountRepo.getUserInfoByID(id: id);

  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  }) async =>
      await _accountRepo.updateSelectedBudget(
        id: id,
        budgetId: budgetId,
      );
}
