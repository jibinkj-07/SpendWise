import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/domain/model/user.dart';
import '../../../transactions/domain/model/transaction_model.dart';

abstract class AnalysisRepo {
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsPerYear({
    required String budgetId,
    required String year,
  });

  Future<Either<Failure, List<User>>> getMembers({required String budgetId});
}
