import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../transactions/domain/model/transaction_model.dart';

abstract class AnalysisFbDataSource {
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsPerYear({
    required String budgetId,
    required String year,
  });
}

class AnalysisFbDataSourceImpl implements AnalysisFbDataSource {
  final FirebaseDatabase _firebaseDatabase;

  AnalysisFbDataSourceImpl(this._firebaseDatabase);

  @override
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsPerYear({
    required String budgetId,
    required String year,
  }) async* {
    try {
      yield* _firebaseDatabase
          .ref(FirebasePath.transactionPath(budgetId))
          .child(year)
          .onValue
          .map<Either<Failure, List<TransactionModel>>>((event) {
        if (event.snapshot.exists) {
          List<TransactionModel> trans = [];
          for (final month in event.snapshot.children) {
            trans.addAll(month.children.map(TransactionModel.fromFirebase));
          }

          // Emit the parsed TransactionModel
          return Right(trans);
        } else {
          return const Right([]);
        }
      }).handleError((error) {
        // Handle stream errors and return a failure
        return Left(
            DatabaseError(message: "An error occurred: ${error.toString()}"));
      }).cast<
              Either<
                  Failure,
                  List<
                      TransactionModel>>>(); // Ensure the correct type is emitted
    } catch (e, stackTrace) {
      log("Error: [analysis_fb_data_source.dart.dart][getTransactionsPerYear] $e, $stackTrace");
      yield Left(DatabaseError(message: "Something went wrong."));
    }
  }
}
