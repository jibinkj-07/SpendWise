import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../model/user.dart';

abstract class AccountRepo {
  Future<Either<Failure, User>> getUserInfoByMail({required String email});

  Future<Either<Failure, User>> getUserInfoByID({required String id});

  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  });
}
