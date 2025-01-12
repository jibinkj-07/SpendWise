import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:spend_wise/features/account/domain/model/user.dart';
import '../../../../core/util/error/failure.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../../domain/repo/analysis_repo.dart';
import '../data_source/analysis_fb_data_source.dart';

class AnalysisRepoImpl implements AnalysisRepo {
  final AnalysisFbDataSource _dataSource;

  AnalysisRepoImpl(this._dataSource);

  @override
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsPerYear({
    required String budgetId,
    required String year,
  }) async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _dataSource.getTransactionsPerYear(
        budgetId: budgetId,
        year: year,
      );
    } else {
      yield Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, List<User>>> getMembers(
      {required String budgetId}) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _dataSource.getMembers(budgetId: budgetId);
    } else {
      return Left(NetworkError());
    }
  }
}
