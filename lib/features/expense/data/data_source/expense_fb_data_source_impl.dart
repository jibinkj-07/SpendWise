import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/expense_model.dart';
import '../../domain/model/transaction_model.dart';
import 'expense_fb_data_source.dart';

class ExpenseFbDataSourceImpl implements ExpenseFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;

  ExpenseFbDataSourceImpl(this._firebaseDatabase, this._firebaseStorage);

  /// PRIVATE INTERNAL FUNCTIONS
  Future<String> _uploadImage(
      {required String path, required XFile image}) async {
    try {
      final reference = _firebaseStorage.ref(path);

      /// Compressing image
      // // Compress the image using the `image` package
      // img.Image? rawImage = img.decodeImage(await image.readAsBytes());
      // if (rawImage != null) {
      //   //  Convert the compressed image back to bytes
      //   List<int> compressedBytes =
      //       img.encodeJpg(rawImage, quality: 85); // Lossless compression
      //
      //   // Save the compressed image temporarily before uploading
      //   Directory tempDir = await getTemporaryDirectory();
      //   String tempPath = '${tempDir.path}/temp_image.jpg';
      //   File tempFile = File(tempPath)..writeAsBytesSync(compressedBytes);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await reference.putData(await image.readAsBytes(), metadata);
      return await reference.getDownloadURL();
      // }
      return "";
    } catch (e) {
      log("er: [_uploadImage][expense_fb_data_source_impl.dart] $e");
      return "";
    }
  }

  Future<void> _deleteAllImagesInFolder(String folderPath) async {
    // Get a reference to the folder
    final Reference folderRef = _firebaseStorage.ref().child(folderPath);

    // List all files in the folder
    final ListResult result = await folderRef.listAll();

    // Delete each file in the folder
    for (Reference fileRef in result.items) {
      await fileRef.delete();
    }

    // Optionally, you could also delete any subfolders
    for (Reference dirRef in result.prefixes) {
      await _deleteAllImagesInFolder(
        dirRef.fullPath,
      );
    }
  }

  @override
  Future<Either<Failure, bool>> insertCategory({
    required String expenseId,
    required CategoryModel category,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(expenseId, category.id))
          .set(category.toJson());
      return const Right(true);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][insertCategory] $e");
      return Left(Failure(message: "Unable to create new category."));
    }
  }

  @override
  Future<Either<Failure, bool>> insertExpense({
    required ExpenseModel expense,
  }) async {
    final date = DateTime.now();
    try {
      await _firebaseDatabase
          .ref(FirebasePath.expensePath(expense.id))
          .set(expense.toJson());

      // Add categories
      for (final category in expense.categories) {
        await _firebaseDatabase
            .ref(FirebasePath.categoryPath(expense.id, category.id))
            .set(category.toJson());
      }

      // Add Transactions
      for (final trans in expense.transactions) {
        await _firebaseDatabase
            .ref(FirebasePath.transactionPath(expense.id, trans.id))
            .set(trans.toJson());
      }

      // Add Invited users into expense node
      for (final user in expense.invitedUsers) {
        await _firebaseDatabase
            .ref(
                "${FirebasePath.expensePath(expense.id)}/invited_users/${user.uid}")
            .set({"invited_on": date.millisecondsSinceEpoch.toString()});

        await _firebaseDatabase
            .ref(
                "${FirebasePath.userNode}/${user.uid}/invited_expenses/${expense.id}")
            .set({"invited_on": date.millisecondsSinceEpoch.toString()});
      }
      // Add expense to joined list of user
      await _firebaseDatabase
          .ref(
              "${FirebasePath.userNode}/${expense.adminId}/joined_expenses/${expense.id}")
          .set({"joined_on": date.millisecondsSinceEpoch.toString()});
      await _firebaseDatabase
          .ref("${FirebasePath.userNode}/${expense.adminId}")
          .update({"current_expense_id": expense.id});
      return const Right(true);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][insertExpense] $e");
      return Left(Failure(message: "Unable to create new expense."));
    }
  }

  @override
  Future<Either<Failure, String>> insertTransaction({
    required String expenseId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    String url = "";
    try {
      await _firebaseDatabase
          .ref(FirebasePath.transactionPath(expenseId, transaction.id))
          .set(transaction.toJson());
      if (doc != null) {
        url = await _uploadImage(
          path: "Images/$expenseId/${transaction.id}.jpg",
          image: doc,
        );
      }
      return Right(url);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][insertTransaction] $e");
      return Left(Failure(message: "Unable to create new transaction."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCategory({
    required String expenseId,
    required String categoryId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(expenseId, categoryId))
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][removeCategory] $e");
      return Left(Failure(message: "Unable to delete this category."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeExpense({
    required String expenseId,
  }) async {
    try {
      await _deleteAllImagesInFolder("Images/$expenseId");
      await _firebaseDatabase.ref(FirebasePath.expensePath(expenseId)).remove();
      return const Right(true);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][removeExpense] $e");
      return Left(Failure(message: "Unable to delete this expense."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeTransaction({
    required String expenseId,
    required String transactionId,
  }) async {
    try {
      try {
        // Deleting transaction image
        await _firebaseStorage
            .ref()
            .child("Images/$expenseId/$transactionId.jpg")
            .delete();
      } catch (e) {
        log("er: [expense_fb_data_source_impl.dart][removeTransaction] $e");
      }

      await _firebaseDatabase
          .ref(FirebasePath.transactionPath(expenseId, transactionId))
          .remove();

      return const Right(true);
    } catch (e) {
      log("er: [expense_fb_data_source_impl.dart][removeTransaction] $e");
      return Left(Failure(message: "Unable to delete this transaction."));
    }
  }
}
