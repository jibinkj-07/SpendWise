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
    required bool fromRequest,
  });

  Future<Either<Failure, BudgetInfo?>> getBudgetInfo({
    required String budgetId,
    required DateTime date,
  });

  Stream<Either<Failure, List<User>>> subscribeMembers({
    required String budgetId,
  });

  Stream<Either<Failure, List<User>>> subscribeRequests({
    required String budgetId,
  });

  Future<Either<Failure, bool>> acceptMemberRequest({
    required String memberId,
    required String budgetId,
    required String budgetName,
  });

  Future<Either<Failure, bool>> requestBudgetJoin({
    required String memberId,
    required String budgetId,
    required String memberName,
  });

  Future<Either<Failure, bool>> acceptBudgetInvitation({
    required String budgetId,
    required String budgetName,
    required String userId,
    required String userName,
  });

  Future<Either<Failure, bool>> removeBudgetInvitation({
    required String budgetId,
    required String budgetName,
    required String userId,
    required String userName,
  });

  Future<Either<Failure, bool>> removeMyBudgetJoinRequest({
    required String budgetId,
    required String userId,
  });

  Stream<Either<Failure, List<BudgetInfo>>> subscribeInvitations({
    required String userId,
  });

  Stream<Either<Failure, List<BudgetInfo>>> subscribeMyInvitationRequests({
    required String userId,
  });
}
