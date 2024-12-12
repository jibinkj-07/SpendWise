import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/model/user.dart';
import '../../domain/repo/account_repo.dart';

class AccountHelper {
  final AccountRepo _accountRepo;
  final AuthBloc _authBloc;

  AccountHelper(this._accountRepo, this._authBloc);

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
  }) async {
    final result =
        await _accountRepo.updateSelectedBudget(id: id, budgetId: budgetId);
    if (result.isRight) {
      _authBloc.add(UpdateUser(selectedBudget: budgetId));
    }
    return result;
  }
}
