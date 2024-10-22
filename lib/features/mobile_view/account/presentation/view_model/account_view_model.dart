import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:my_budget/core/util/helper/firebase_mapper.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';

import '../../../../../core/util/error/failure.dart';
import '../../../auth/data/data_source/auth_fb_data_source.dart';

sealed class AccountViewModel {
  static Future<List<UserModel>> getMembers(DataSnapshot snapshot) async {
    List<UserModel> members = [];
    final authFbDataSource = AuthFbDataSourceImpl(
      FirebaseAuth.instance,
      FirebaseDatabase.instance,
    );
    for (final member in snapshot.children) {
      final user =
          await authFbDataSource.getUserDetail(uid: member.key.toString());
      if (user.isRight) {
        members.add(
          user.right.copyWith(
            addedOn: DateTime.fromMillisecondsSinceEpoch(
              int.parse(member.child("added_on").value.toString()),
            ),
          ),
        );
      }
    }
    return members;
  }

  static Future<Either<Failure, void>> addMember({
    required String memberEmail,
    required String adminId,
  }) async {
    String memberId = "";
    if (await InternetConnection().hasInternetAccess) {
      try {
        final data =
            await FirebaseDatabase.instance.ref(FirebaseMapper.userNode).get();
        for (final user in data.children) {
          if (user.child("email").value.toString() == memberEmail) {
            memberId = user.key.toString();
          }
        }

        if (memberId.isEmpty) {
          return Left(Failure(message: "No user found with provided email"));
        } else {
          await FirebaseDatabase.instance
              .ref("${FirebaseMapper.memberPath(adminId)}/$memberId")
              .update(
            {"added_on": DateTime.now().millisecondsSinceEpoch.toString()},
          );
          // update adminid for member path
          await FirebaseDatabase.instance
              .ref(FirebaseMapper.userPath(memberId))
              .update(
            {"admin_id": adminId},
          );
          return const Right(null);
        }
      } catch (e) {
        log("er[account_view_model.dart][addMember] $e");
        return Left(Failure(message: "Something went wrong"));
      }
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }

  static Future<Either<Failure, void>> deleteMember({
    required String memberId,
    required String adminId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      try {
        await FirebaseDatabase.instance
            .ref(FirebaseMapper.memberPath(adminId))
            .child(memberId)
            .remove();
        // update adminid for member path
        await FirebaseDatabase.instance
            .ref(FirebaseMapper.userPath(memberId))
            .update(
          {"admin_id": ""},
        );
        return const Right(null);
      } catch (e) {
        log("er[account_view_model.dart][deleteMember] $e");
        return Left(Failure(message: "Something went wrong"));
      }
    } else {
      return Left(Failure(message: "Check your internet connection"));
    }
  }
}
