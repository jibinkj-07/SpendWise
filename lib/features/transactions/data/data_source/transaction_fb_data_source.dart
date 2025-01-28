import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../domain/model/transaction_model.dart';

abstract class TransactionFbDataSource {
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
    required DateTime transactionDate,
  });
}

class TransactionFbDataSourceImpl implements TransactionFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;

  TransactionFbDataSourceImpl(this._firebaseDatabase, this._firebaseStorage);

  @override
  Future<Either<Failure, void>> addTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    String url = transaction.docUrl;
    try {
      if (doc != null) {
        url = await _uploadImage(
          path: "Images/$budgetId/${transaction.id}.jpg",
          image: doc,
        );
      }
      final transId =
          "${transaction.id}-${transaction.createdUserId.substring(0, 5)}";
      await _firebaseDatabase
          .ref(FirebasePath.transactions(budgetId))
          .child("${transaction.date.year}")
          .child("${transaction.date.month}")
          .child(transId)
          .set(transaction.toJson(url));

      return const Right(null);
    } catch (e) {
      log("er: [transaction_fb_data_source_impl.dart][addTransaction] $e");
      return Left(
        DatabaseError(message: "Unable to add this transaction."),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction({
    required String budgetId,
    required String transactionId,
    required DateTime transactionDate,
  }) async {
    try {
      try {
        // Deleting transaction image
        await _firebaseStorage
            .ref()
            .child("Images/$budgetId/$transactionId.jpg")
            .delete();
      } catch (e) {
        log("er: [transaction_fb_data_source_impl.dart][deleteTransaction] $e");
      }

      await _firebaseDatabase
          .ref(FirebasePath.transactions(budgetId))
          .child("${transactionDate.year}")
          .child("${transactionDate.month}")
          .child(transactionId)
          .remove();

      return const Right(null);
    } catch (e) {
      log("er: [transaction_fb_data_source_impl.dart][deleteTransaction] $e");
      return Left(Failure(message: "Unable to delete this transaction."));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionModel>>> subscribeMonthlyTransactions({
    required String budgetId,
    required DateTime date,
  }) async* {
    try {
      yield* _firebaseDatabase
          .ref(FirebasePath.transactions(budgetId))
          .child("${date.year}")
          .child("${date.month}")
          .onValue
          .map<Either<Failure, List<TransactionModel>>>((event) {
        if (event.snapshot.exists) {
          try {
            // Parse the transaction snapshot into a TransactionModel
            final List<TransactionModel> transactions = event.snapshot.children
                .map((item) => TransactionModel.fromFirebase(item))
                .toList();
            return Right(transactions); // Emit the parsed TransactionModel
          } catch (e) {
            return Left(
              DatabaseError(message: "Failed to parse transaction data: $e"),
            );
          }
        } else {
          return const Right([]);
        }
      }).cast<Either<Failure, List<TransactionModel>>>();
    } catch (e, stackTrace) {
      log("Error: [transaction_fb_data_source_impl.dart][subscribeMonthlyTransactions] $e, $stackTrace");
      yield Left(DatabaseError(message: "Something went wrong."));
    }
  }

  /// PRIVATE INTERNAL FUNCTIONS
  Future<String> _uploadImage({
    required String path,
    required XFile image,
  }) async {
    try {
      final reference = _firebaseStorage.ref(path);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await reference.putData(await image.readAsBytes(), metadata);
      return await reference.getDownloadURL();
    } catch (e) {
      log("er: [_uploadImage][transaction_fb_data_source_impl.dart] $e");
      return "";
    }
  }
}
