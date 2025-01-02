import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../model/transaction_model.dart';

abstract class TransactionRepo {
  Stream<Either<Failure, List<TransactionModel>>> subscribeMonthlyTransactions({
    required String budgetId,
    required DateTime date,
  });

  Future<Either<Failure, void>> addTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  });

  Future<Either<Failure, void>> deleteTransaction({
    required String budgetId,
    required String transactionId,
    required DateTime createdDate,
  });
}
