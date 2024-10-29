import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_budget/core/util/helper/firebase_mapper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../../core/util/error/failure.dart';
import '../../../mobile_view/auth/data/data_source/auth_fb_data_source.dart';
import '../model/expense_model.dart';
import '../model/user_model.dart';

abstract class ExpenseFbDataSource {
  Future<Either<Failure, ExpenseModel>> addExpense({
    required ExpenseModel expenseModel,
    required UserModel user,
    required List<XFile> documents,
  });

  Future<Either<Failure, void>> deleteExpense({
    required String adminId,
    required ExpenseModel expense,
  });

  Future<Either<Failure, List<ExpenseModel>>> getAllExpense({
    required String adminId,
    required DateTime date,
  });
}

class ExpenseFbDataSourceImpl implements ExpenseFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;
  final AuthFbDataSource _authFbDataSource;

  ExpenseFbDataSourceImpl(
    this._firebaseDatabase,
    this._firebaseStorage,
    this._authFbDataSource,
  );

  @override
  Future<Either<Failure, ExpenseModel>> addExpense({
    required ExpenseModel expenseModel,
    required UserModel user,
    required List<XFile> documents,
  }) async {
    List<String> urls = [];
    try {
      // Uploading images into cloud storage bucket
      for (final doc in documents) {
        urls.add(
          await _uploadImage(
            path: "${user.adminId}/Expense Doc/${expenseModel.id}"
                "/${DateTime.now().millisecondsSinceEpoch}.jpg",
            image: doc,
          ),
        );
      }

      await _firebaseDatabase
          .ref(FirebaseMapper.expensePath(user.adminId))
          .child("${expenseModel.date.year}/${expenseModel.date.month}")
          .update(
            expenseModel.toFirebaseJson(urls),
          );
      return Right(expenseModel.copyWith(documents: urls));
    } catch (e) {
      log("er[addExpense][expense_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense({
    required String adminId,
    required ExpenseModel expense,
  }) async {
    try {
      // Delete all stored images
      await _deleteAllImagesInFolder("$adminId/Expense Doc/${expense.id}");
      await _firebaseDatabase
          .ref(FirebaseMapper.expensePath(adminId))
          .child("${expense.date.year}/${expense.date.month}/${expense.id}")
          .remove();
      return const Right(null);
    } catch (e) {
      log("er[deleteExpense][expense_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseModel>>> getAllExpense({
    required String adminId,
    required DateTime date,
  }) async {
    // Fetching expense data of passing date year
    List<ExpenseModel> items = [];
    try {
      final result = await _firebaseDatabase
          .ref(FirebaseMapper.expensePath(adminId))
          .child("${date.year}")
          .get();
      final categoryRootSnapshot = await _firebaseDatabase
          .ref(FirebaseMapper.categoryPath(adminId))
          .get();
      if (result.exists) {
        for (final month in result.children) {
          for (final expense in month.children) {
            final userId = expense.child("created_by").value.toString();
            final user = await _authFbDataSource.getUserDetail(uid: userId);
            if (user.isRight) {
              items.add(
                ExpenseModel.fromFirebase(
                  expense,
                  categoryRootSnapshot,
                  user.right,
                ),
              );
            }
          }
        }
      }
      return Right(items);
    } catch (e) {
      log("er[getAllExpense][expense_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong"));
    }
  }

  Future<String> _uploadImage({
    required String path,
    required XFile image,
  }) async {
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
      log("er: [_uploadImage][inventory_fb_data_source_impl.dart] $e");
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
          dirRef.fullPath); // Recursively delete subfolders
    }
  }
}
