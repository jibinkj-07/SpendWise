import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../model/budget_info.dart';
import '../model/user.dart';

abstract class AccountRepo {
  Future<Either<Failure, User>> getUserInfoByMail({required String email});

  Future<Either<Failure, User>> getUserInfoByID({required String id});

  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  });

  Future<Either<Failure, bool>> updateUserImage({
    required String userId,
    required String profileName,
  });

  Future<Either<Failure, bool>> inviteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  });

  Future<Either<Failure, bool>> deleteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  });
  Future<Either<Failure, BudgetInfo?>> getBudgetInfo(
      {required String budgetId});
}
