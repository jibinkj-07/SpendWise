import 'dart:developer';

import 'package:currency_picker/currency_picker.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';
import 'package:spend_wise/features/account/domain/model/user.dart';
import 'package:spend_wise/features/budget/domain/model/budget_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/util/error/failure.dart';
import '../../../account/data/data_source/account_fb_data_source.dart';
import '../../domain/model/category_model.dart';
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

  @override
  Stream<Either<Failure, List<CategoryModel>>> subscribeCategory({
    required String budgetId,
  }) async* {
    try {
      yield* _firebaseDatabase
          .ref(FirebasePath.budgetPath(budgetId))
          .child("categories")
          .onValue
          .map<Either<Failure, List<CategoryModel>>>((event) {
        if (event.snapshot.exists) {
          try {
            // Parse the category snapshot into a CategoryModel
            final List<CategoryModel> categories = event.snapshot.children
                .map((category) => CategoryModel.fromFirebase(category))
                .toList();
            return Right(categories); // Emit the parsed CategoryModel
          } catch (e) {
            return Left(
              DatabaseError(message: "Failed to parse category data: $e"),
            );
          }
        } else {
          return const Right([]);
        }
      }).handleError((error) {
        // Handle stream errors and return a failure
        return Left(
            DatabaseError(message: "An error occurred: ${error.toString()}"));
      }).cast<
              Either<Failure,
                  List<CategoryModel>>>(); // Ensure the correct type is emitted
    } catch (e, stackTrace) {
      log("Error: [budget_fb_data_source_impl.dart][subscribeCategory] $e, $stackTrace");
      yield Left(DatabaseError(message: "Something went wrong."));
    }
  }

  @override
  Future<Either<Failure, bool>> addCategory({
    required String budgetId,
    required CategoryModel category,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(budgetId, category.id))
          .set(category.toJson());
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][addCategory] $e");
      return Left(Failure(message: "Unable to create new category."));
    }
  }

  @override
  Stream<Either<Failure, BudgetModel>> subscribeBudget({
    required String budgetId,
  }) async* {
    try {
      yield* _firebaseDatabase
          .ref(FirebasePath.budgetDetailPath(budgetId))
          .onValue
          .map<Either<Failure, BudgetModel>>((event) {
        if (event.snapshot.exists) {
          try {
            // Parse the budget snapshot into a BudgetModel
            final BudgetModel budget = BudgetModel.fromFirebase(
              event.snapshot,
              budgetId,
            );
            return Right(budget); // Emit the parsed BudgetModel
          } catch (e) {
            return Left(
              DatabaseError(message: "Failed to parse budget data: $e"),
            );
          }
        } else {
          return Left(
            DatabaseError(
                message:
                    "Unable to retrieve budget details. The data might have been deleted,"
                    " or you may not have access to this budget."
                    " Please contact the administrator for further assistance."),
          );
        }
      }).handleError((error) {
        // Handle stream errors and return a failure
        return Left(
            DatabaseError(message: "An error occurred: ${error.toString()}"));
      }).cast<
              Either<Failure,
                  BudgetModel>>(); // Ensure the correct type is emitted
    } catch (e, stackTrace) {
      log("Error: [budget_fb_data_source_impl.dart][subscribeBudget] $e, $stackTrace");
      yield Left(DatabaseError(message: "Something went wrong."));
    }
  }

  @override
  Future<Either<Failure, bool>> addBudget({
    required String name,
    required String admin,
    required List<CategoryModel> categories,
    required Currency currency,
    required List<User> members,
  }) async {
    final id = Uuid().v1();
    final date = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      // Add budget basic data
      await _firebaseDatabase.ref(FirebasePath.budgetDetailPath(id)).set({
        "name": name,
        "admin": admin,
        "currency": currency.name,
        "currency_symbol": currency.symbol,
        "created_on": date,
      });
      // Adding owner id into member node of budget
      await _firebaseDatabase
          .ref(FirebasePath.budgetPath(id))
          .child("members/$admin")
          .set({
        "status": "joined",
        "date": date,
      });
      // Add Categories
      for (final item in categories) {
        await _firebaseDatabase
            .ref(FirebasePath.categoryPath(id, item.id))
            .set(item.toJson());
      }

      // Add members and invitation into member node
      for (final user in members) {
        await _firebaseDatabase
            .ref(FirebasePath.budgetPath(id))
            .child("members/${user.uid}")
            .set({
          "status": "pending",
          "date": date,
        });

        // Adding invitation to members node
        await _firebaseDatabase
            .ref(FirebasePath.invitationPath(user.uid))
            .child(id)
            .set({
          "date": date,
        });

        // Adding notification to corresponding users
        await _firebaseDatabase
            .ref(FirebasePath.notificationPath(user.uid))
            .child(date)
            .set({
          "title": "Budget Invitation",
          "body": "You have a new invitation to join the budget \"$name\"",
          "time": date,
        });

        // Toggle notification status to true
        await _firebaseDatabase
            .ref(FirebasePath.userPath(user.uid))
            .update({"notification_status": true});
      }

      // Adding current budget to joined budget node for owner
      await _firebaseDatabase
          .ref(FirebasePath.joinedBudgetPath(admin))
          .child(id)
          .set({"date": date});

      // Call the account class function to update selection to current budget to admin node
      return await _accountFbDataSource.updateSelectedBudget(
        id: admin,
        budgetId: id,
      );
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][addBudget] $e");
      return Left(Failure(message: "Unable to create new budget."));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCategory({
    required String budgetId,
    required String categoryId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.categoryPath(budgetId, categoryId))
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][deleteCategory] $e");
      return Left(Failure(message: "Unable to delete this category."));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBudget({
    required String budgetId,
  }) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch.toString();
      await _deleteAllImagesInFolder("Images/$budgetId");
      // Get all budget members
      await _firebaseDatabase
          .ref(FirebasePath.budgetPath(budgetId))
          .once()
          .then((event) async {
        if (event.snapshot.exists) {
          final budgetDetail = event.snapshot.child("details");
          final budgetMembers = event.snapshot.child("members");
          for (final member in budgetMembers.children) {
            final memberId = member.key.toString();
            // Add Notification to all members
            await _firebaseDatabase
                .ref(FirebasePath.notificationPath(memberId))
                .child(date)
                .set({
              "title": "Budget Deleted",
              "body":
                  "\"${budgetDetail.child("name").value}\" has been deleted.",
              "time": date,
            });

            // Toggle notification status to true
            await _firebaseDatabase
                .ref(FirebasePath.userPath(memberId))
                .update({"notification_status": true});
            // Remove budget from members node
            await _firebaseDatabase
                .ref(FirebasePath.invitationPath(memberId))
                .child(budgetId)
                .remove();
            await _firebaseDatabase
                .ref(FirebasePath.joinedBudgetPath(memberId))
                .child(budgetId)
                .remove();
          }
        }
      });

      await _firebaseDatabase.ref(FirebasePath.budgetPath(budgetId)).remove();
      return const Right(true);
    } catch (e) {
      log("er: [budget_fb_data_source_impl.dart][deleteBudget] $e");
      return Left(Failure(message: "Unable to delete this budget."));
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
}
