import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';
import 'package:spend_wise/features/account/domain/model/user.dart';
import 'package:spend_wise/features/budget/domain/model/goal_model.dart';
import 'package:spend_wise/features/budget/domain/model/goal_trans_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/data/data_source/account_fb_data_source.dart';
import '../../domain/model/category_model.dart';
import '../../domain/model/transaction_model.dart';
import 'budget_fb_data_source.dart';

class BudgetFbDataSourceImpl implements BudgetFbDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;
  final AccountFbDataSource _accountFbDataSource;

  BudgetFbDataSourceImpl(
    this._firebaseDatabase,
    this._firebaseStorage,
    this._accountFbDataSource,
  );

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
      log("er: [_uploadImage][budget_fb_data_source_impl.dart] $e");
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
    required String budgetId,
    required CategoryModel category,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(budgetId, category.id))
          .set(category.toJson());
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][insertCategory] $e");
      return Left(Failure(message: "Unable to create new category."));
    }
  }

  @override
  Future<Either<Failure, bool>> insertBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories,
    required List<String> accountTypes,
    required List<User> members,
  }) async {
    final id = Uuid().v1();
    try {
      // Add budget basic data
      await _firebaseDatabase.ref(FirebasePath.budgetPath(id)).set({
        "name": name,
        "admin": admin,
      });

      // Add Categories
      for (final item in categories) {
        await _firebaseDatabase
            .ref(FirebasePath.categoryPath(id, item.id))
            .set(item.toJson());
      }

      // Add account types
      await _firebaseDatabase
          .ref(FirebasePath.budgetPath(id))
          .child("account_types")
          .set(accountTypes);

      final date = DateTime.now().millisecondsSinceEpoch.toString();
      // Add members and invitation into member node
      for (final user in members) {
        await _firebaseDatabase
            .ref(FirebasePath.budgetPath(id))
            .child("members/${user.uid}")
            .set({
          "status": "pending",
          "date": date,
        });

        await _firebaseDatabase
            .ref(FirebasePath.invitationPath(user.uid))
            .child(id)
            .set({
          "date": date,
        });
      }

      // Call the account class function to update selection to current budget to admin node
      return await _accountFbDataSource.updateSelectedBudget(
        id: admin,
        budgetId: id,
      );
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][insertBudget] $e");
      return Left(Failure(message: "Unable to create new budget."));
    }
  }

  @override
  Future<Either<Failure, bool>> insertGoal({
    required String budgetId,
    required GoalModel goal,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.goalPath(budgetId, goal.id))
          .set(goal.toJson());
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][insertGoal] $e");
      return Left(Failure(message: "Unable to create goal."));
    }
  }

  @override
  Future<Either<Failure, bool>> insertGoalTransaction({
    required String budgetId,
    required String goalId,
    required GoalTransModel transaction,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.goalPath(budgetId, goalId))
          .child("history/${transaction.id}")
          .set(transaction.toJson());
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][insertGoalTransaction] $e");
      return Left(Failure(message: "Unable to create new transaction."));
    }
  }

  @override
  Future<Either<Failure, String>> insertTransaction({
    required String budgetId,
    required TransactionModel transaction,
    XFile? doc,
  }) async {
    String url = "";
    try {
      if (doc != null) {
        url = await _uploadImage(
          path: "Images/$budgetId/${transaction.id}.jpg",
          image: doc,
        );
      }
      await _firebaseDatabase
          .ref(FirebasePath.transactionPath(budgetId, transaction.id))
          .set(transaction.toJson(url));

      return Right(url);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][insertTransaction] $e");
      return Left(Failure(message: "Unable to create new transaction."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCategory({
    required String budgetId,
    required String categoryId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(budgetId, categoryId))
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][removeCategory] $e");
      return Left(Failure(message: "Unable to delete this category."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBudget({
    required String budgetId,
  }) async {
    try {
      await _deleteAllImagesInFolder("Images/$budgetId");
      await _firebaseDatabase.ref(FirebasePath.budgetPath(budgetId)).remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][removeBudget] $e");
      return Left(Failure(message: "Unable to delete this budget."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeGoal({
    required String budgetId,
    required String goalId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.goalPath(budgetId, goalId))
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][removeGoal] $e");
      return Left(Failure(message: "Unable to delete this goal."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeGoalTransaction({
    required String budgetId,
    required String goalId,
    required String transactionId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.goalPath(budgetId, goalId))
          .child("history/$transactionId")
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][removeGoalTransaction] $e");
      return Left(Failure(message: "Unable to delete this transaction."));
    }
  }

  @override
  Future<Either<Failure, bool>> removeTransaction({
    required String budgetId,
    required String transactionId,
  }) async {
    try {
      try {
        // Deleting transaction image
        await _firebaseStorage
            .ref()
            .child("Images/$budgetId/$transactionId.jpg")
            .delete();
      } catch (e) {
        log("er: [budget_fb_data_source_impl.dart][removeTransaction] $e");
      }

      await _firebaseDatabase
          .ref(FirebasePath.transactionPath(budgetId, transactionId))
          .remove();

      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][removeTransaction] $e");
      return Left(Failure(message: "Unable to delete this transaction."));
    }
  }
}
