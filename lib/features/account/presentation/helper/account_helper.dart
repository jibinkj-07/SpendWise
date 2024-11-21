import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/model/user.dart';

class AccountHelper {
  final FirebaseDatabase _firebaseDatabase;

  AccountHelper(this._firebaseDatabase);

  Future<Either<Failure, User>> getUser(String email) async {
    try {
      final result = await _firebaseDatabase.ref(FirebasePath.userNode).get();
      if (result.exists) {
        for (final user in result.children) {
          if (user.child("email").value.toString() == email) {
            return Right(
              User(
                imageUrl: user.child("profile_url").value.toString(),
                date: DateTime.now(),
                uid: user.key.toString(),
                email: user.child("email").value.toString(),
                firstName: user.child("first_name").value.toString(),
                lastName: user.child("last_name").value.toString(),
                userStatus: UserStatus.pending,
              ),
            );
          }
        }
      }
      return Left(Failure(message: "No user registered with this email"));
    } catch (e) {
      log("er:[account_helper.dart][getUser] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final result =
          await _firebaseDatabase.ref("${FirebasePath.userNode}/$id").get();
      if (result.exists) {
        return Right(
          User(
            imageUrl: result.child("profile_url").value.toString(),
            date: DateTime.now(),
            uid: result.key.toString(),
            email: result.child("email").value.toString(),
            firstName: result.child("first_name").value.toString(),
            lastName: result.child("last_name").value.toString(),
            userStatus: UserStatus.pending,
          ),
        );
      }
      return Left(Failure(message: "No user registered with this email"));
    } catch (e) {
      log("er:[account_helper.dart][getUser] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  Future<Either<Failure, bool>> sendInvitation({
    required String expenseId,
    required User user,
  }) async {
    final date = DateTime.now();
    try {
      // Add inside invited expenses in user node
      await _firebaseDatabase
          .ref(
              "${FirebasePath.userNode}/${user.uid}/invited_expenses/$expenseId")
          .set({"invited_on": date.millisecondsSinceEpoch});
      // Add inside corresponding expense node invited members
      await _firebaseDatabase
          .ref(
              "${FirebasePath.expenseNode}/$expenseId/invited_users/${user.uid}")
          .set({"invited_on": date.millisecondsSinceEpoch});
      return const Right(true);
    } catch (e) {
      log("er:[account_helper.dart][sendInvitation] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }
}
