import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../account/data/data_source/account_fb_data_source.dart';
import '../../../account/domain/model/user.dart';
import '../../../transactions/domain/model/transaction_model.dart';

abstract class AnalysisFbDataSource {
  Stream<Either<Failure, List<TransactionModel>>> getTransactionsPerYear({
    required String budgetId,
    required String year,
  });

  Future<Either<Failure, List<User>>> getMembers({required String budgetId});
}

class AnalysisFbDataSourceImpl implements AnalysisFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final AccountFbDataSource _accountFbDataSource;

  AnalysisFbDataSourceImpl(
    this._firebaseDatabase,
    this._accountFbDataSource,
  );

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

  @override
  Future<Either<Failure, List<User>>> getMembers(
      {required String budgetId}) async {
    try {
      return await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .once()
          .then((event) async {
        if (event.snapshot.exists) {
          List<User> members = [];
          for (final member in event.snapshot.children) {
            final userData = await _accountFbDataSource.getUserInfoByID(
                id: member.key.toString());
            if (userData.isRight) {
              members.add(
                User(
                  uid: member.key.toString(),
                  name: userData.right.name,
                  email: userData.right.email,
                  imageUrl: userData.right.imageUrl,
                  userStatus: member.child("status").value.toString(),
                  date: DateTime.fromMillisecondsSinceEpoch(
                    int.parse(member.child("date").value.toString()),
                  ),
                ),
              );
            }
          }

          return Right(members);
        }
        return Left(DatabaseError(message: "Unable to fetch members"));
      });
    } catch (e) {
      log("Error: [analysis_fb_data_source.dart.dart][getMembers] $e");
      return Left(DatabaseError(message: "Unable to fetch members"));
    }
  }
}
