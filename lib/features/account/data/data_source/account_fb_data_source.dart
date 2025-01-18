import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../../core/util/helper/notification.dart';
import '../../domain/model/user.dart';

abstract class AccountFbDataSource {
  Future<Either<Failure, User>> getUserInfoByMail({required String email});

  Future<Either<Failure, User>> getUserInfoByID({required String id});

  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  });

  Future<Either<Failure, bool>> updateUserImage({
    required String userId,
    required String profileName,
  });

  Future<Either<Failure, bool>> inviteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  });

  Future<Either<Failure, bool>> deleteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  });
}

class AccountFbDataSourceImpl implements AccountFbDataSource {
  final FirebaseDatabase _firebaseDatabase;

  AccountFbDataSourceImpl(this._firebaseDatabase);

  @override
  Future<Either<Failure, User>> getUserInfoByID({required String id}) async {
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
            name: result.child("name").value.toString(),
            userStatus: "",
          ),
        );
      }
      return Left(Failure(message: "No user registered with this email"));
    } catch (e) {
      log("er:[account_fb_data_source.dart][getUserInfoByID] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, User>> getUserInfoByMail({
    required String email,
  }) async {
    try {
      final result = await _firebaseDatabase.ref(FirebasePath.userNode).once();
      if (result.snapshot.exists) {
        for (final user in result.snapshot.children) {
          if (user.child("email").value.toString() == email) {
            return Right(
              User(
                imageUrl: user.child("profile_url").value.toString(),
                date: DateTime.now(),
                uid: user.key.toString(),
                email: user.child("email").value.toString(),
                name: user.child("name").value.toString(),
                userStatus: "",
              ),
            );
          }
        }
      }
      return Left(Failure(message: "No user registered with this email"));
    } catch (e) {
      log("er:[account_fb_data_source.dart][getUserInfoByMail] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateSelectedBudget({
    required String id,
    required String budgetId,
  }) async {
    try {
      String budget = budgetId;
      if (budgetId.trim().isEmpty) {
        await _firebaseDatabase
            .ref(FirebasePath.joinedBudgetPath(id))
            .once()
            .then((event) {
          if (event.snapshot.exists) {
            budget = event.snapshot.children.first.key.toString();
          }
        });
      }

      await _firebaseDatabase.ref(FirebasePath.userPath(id)).update(
        {"selected": budget},
      );
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source.dart][updateSelectedBudget] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserImage({
    required String userId,
    required String profileName,
  }) async {
    try {
      await _firebaseDatabase.ref(FirebasePath.userPath(userId)).update(
        {"profile_url": profileName},
      );
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source.dart][updateUserImage] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  }) async {
    try {
      // Remove from user joined and invitation node
      await _firebaseDatabase
          .ref(FirebasePath.joinedBudgetPath(memberId))
          .child(budgetId)
          .remove();
      await _firebaseDatabase
          .ref(FirebasePath.invitationPath(memberId))
          .child(budgetId)
          .remove();
      // Remove user from budget node
      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .child(memberId)
          .remove();

      // Add notification to user
      final date = DateTime.now().millisecondsSinceEpoch.toString();
      await _firebaseDatabase
          .ref(FirebasePath.notificationPath(memberId))
          .child(date)
          .set({
        "title": Notification.accessRevoked,
        "body":
            "Your access to the budget \"$budgetName\" has been revoked by admin",
        "time": date,
      });
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source.dart][deleteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> inviteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
  }) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch.toString();
      // Add user into budget node
      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .child(memberId)
          .set({
        "status": "pending",
        "date": date,
      });

      // Add budget into member invitation node

      await _firebaseDatabase
          .ref(FirebasePath.invitationPath(memberId))
          .child(budgetId)
          .set({
        "date": date,
      });

      // Add notification to user
      await _firebaseDatabase
          .ref(FirebasePath.notificationPath(memberId))
          .child(date)
          .set({
        "title": Notification.budgetInvitation,
        "body": "You have a new invitation to join the budget \"$budgetName\"",
        "time": date,
      });
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source.dart][inviteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }
}
