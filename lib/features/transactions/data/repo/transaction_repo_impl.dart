import 'package:either_dart/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../../core/util/error/failure.dart';
import '../../domain/model/transaction_model.dart';
import '../../domain/repo/transaction_repo.dart';
import '../data_source/transaction_fb_data_source.dart';

class TransactionRepoImpl implements TransactionRepo {
  final TransactionFbDataSource _dataSource;

  TransactionRepoImpl(this._dataSource);

  @override
  Future<Either<Failure, void>> addTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _dataSource.addTransaction(
        budgetId: budgetId,
        transaction: transaction,
        doc: doc,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction({
    required String budgetId,
    required String transactionId,
    required DateTime transactionDate,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _dataSource.deleteTransaction(
        budgetId: budgetId,
        transactionId: transactionId,
        transactionDate: transactionDate,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Stream<Either<Failure, List<TransactionModel>>> subscribeMonthlyTransactions({
    required String budgetId,
    required DateTime date,
  }) async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _dataSource.subscribeMonthlyTransactions(
        budgetId: budgetId,
        date: date,
      );
    } else {
      yield Left(NetworkError());
    }
  }
}
