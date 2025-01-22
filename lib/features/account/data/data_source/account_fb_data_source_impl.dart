import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/constant/constants.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../../core/util/helper/notification.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../../domain/model/budget_info.dart';
import '../../domain/model/user.dart';
import 'account_fb_data_source.dart';

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
      log("er:[account_fb_data_source_impl.dart][getUserInfoByID] $e");
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
      log("er:[account_fb_data_source_impl.dart][getUserInfoByMail] $e");
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
      log("er:[account_fb_data_source_impl.dart][updateSelectedBudget] $e");
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
      log("er:[account_fb_data_source_impl.dart][updateUserImage] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMember({
    required String memberId,
    required String budgetId,
    required String budgetName,
    required bool fromRequest,
  }) async {
    try {
      // Remove from user joined and invitation node
      await _firebaseDatabase
          .ref(FirebasePath.joinedBudgetPath(memberId))
          .child(budgetId)
          .remove();
      if (fromRequest) {
        await _firebaseDatabase
            .ref(FirebasePath.budgetRequestPath(budgetId))
            .child(memberId)
            .remove();
        await _firebaseDatabase
            .ref(FirebasePath.userRequestPath(memberId))
            .child(budgetId)
            .remove();
      } else {
        await _firebaseDatabase
            .ref(FirebasePath.invitationPath(memberId))
            .child(budgetId)
            .remove();
        // Remove user from budget node
        await _firebaseDatabase
            .ref(FirebasePath.membersPath(budgetId))
            .child(memberId)
            .remove();
      }

      // Add notification to user
      final date = DateTime.now().millisecondsSinceEpoch.toString();
      await _firebaseDatabase
          .ref(FirebasePath.notificationPath(memberId))
          .child(date)
          .set({
        "title": Notification.accessRevoked,
        "body":
            "Your ${fromRequest ? "Request" : "Access"} to the budget \"$budgetName\" has been revoked by admin",
        "time": date,
      });

      // Toggle notification status to true
      await _firebaseDatabase
          .ref(FirebasePath.userPath(memberId))
          .update({"notification_status": true});
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][deleteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptMemberRequest({
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
        "status": "joined",
        "date": date,
      });

      // Add budget into member joined node
      await _firebaseDatabase
          .ref(FirebasePath.joinedBudgetPath(memberId))
          .child(budgetId)
          .set({
        "date": date,
      });
      // Remove the requests from user and budget nodes
      await _firebaseDatabase
          .ref(FirebasePath.budgetRequestPath(budgetId))
          .child(memberId)
          .remove();
      await _firebaseDatabase
          .ref(FirebasePath.userRequestPath(memberId))
          .child(budgetId)
          .remove();
      // Add notification to user
      await _firebaseDatabase
          .ref(FirebasePath.notificationPath(memberId))
          .child(date)
          .set({
        "title": Notification.requestAccepted,
        "body":
            "Your request to join the budget \"$budgetName\" has been accepted",
        "time": date,
      });
      // Toggle notification status to true
      await _firebaseDatabase
          .ref(FirebasePath.userPath(memberId))
          .update({"notification_status": true});
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][acceptMemberRequest] $e");
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
      // Toggle notification status to true
      await _firebaseDatabase
          .ref(FirebasePath.userPath(memberId))
          .update({"notification_status": true});
      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][inviteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> requestBudgetJoin({
    required String memberId,
    required String budgetId,
    required String memberName,
  }) async {
    try {
      List<String> memberJoinedBudgets = [];
      final result = await getBudgetInfo(
        budgetId: budgetId,
        date: DateTime.now(),
      );
      if (result.isRight && result.right != null) {
        await _firebaseDatabase
            .ref(FirebasePath.joinedBudgetPath(memberId))
            .once()
            .then((event) {
          for (final budget in event.snapshot.children) {
            memberJoinedBudgets.add(budget.key.toString());
          }
        });

        if (memberJoinedBudgets.contains(budgetId)) {
          return Left(
            Failure(message: "Already you are a member of this budget"),
          );
        }
        final date = DateTime.now().millisecondsSinceEpoch.toString();
        // Add user into budget node
        await _firebaseDatabase
            .ref(FirebasePath.budgetRequestPath(budgetId))
            .child(memberId)
            .set({
          "status": kRequested,
          "date": date,
        });

        // Add budget into member requested node
        await _firebaseDatabase
            .ref(FirebasePath.userRequestPath(memberId))
            .child(budgetId)
            .set({
          "date": date,
        });

        // Add notification to admin
        await _firebaseDatabase
            .ref(FirebasePath.notificationPath(result.right!.admin.uid))
            .child(date)
            .set({
          "title": Notification.joinRequest,
          "body":
              "You have a new request from \"$memberName\" to join \"${result.right!.budget.name}\" budget ",
          "time": date,
        });
        // Toggle notification status to true
        await _firebaseDatabase
            .ref(FirebasePath.userPath(result.right!.admin.uid))
            .update({"notification_status": true});

        return const Right(true);
      } else {
        return Left(
          Failure(message: "Unable to find budget with provided ID. Try again"),
        );
      }
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][inviteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, BudgetInfo?>> getBudgetInfo({
    required String budgetId,
    required DateTime date,
  }) async {
    BudgetInfo? budget;
    try {
      await _firebaseDatabase
          .ref(FirebasePath.budgetDetailPath(budgetId))
          .once()
          .then((event) async {
        if (event.snapshot.exists) {
          final admin = await getUserInfoByID(
              id: event.snapshot.child("admin").value.toString());
          if (admin.isRight) {
            final budgetModel =
                BudgetModel.fromFirebase(event.snapshot, budgetId);
            budget = BudgetInfo(
              budget: budgetModel,
              admin: admin.right,
              date: date,
            );
          }
        }
      });
      return Right(budget);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][inviteMember] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Stream<Either<Failure, List<User>>> subscribeMembers({
    required String budgetId,
  }) async* {
    try {
      final stream = _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .onValue
          .asyncMap<Either<Failure, List<User>>>((event) async {
        try {
          List<User> members = [];
          if (event.snapshot.exists) {
            for (final member in event.snapshot.children) {
              final result = await getUserInfoByID(id: member.key.toString());
              if (result.isRight) {
                final status =
                    member.child("status").value?.toString() ?? "unknown";
                final joinedDate = DateTime.fromMillisecondsSinceEpoch(
                  int.tryParse(member.child("date").value?.toString() ?? "0") ??
                      0,
                );
                final user = result.right.copyWith(
                  date: joinedDate,
                  userStatus: status,
                );
                members.add(user);
              }
            }
          }
          return Right(members);
        } catch (e) {
          return Left(
            DatabaseError(message: "Error processing members: ${e.toString()}"),
          );
        }
      });

      yield* stream.handleError((error) {
        return Left(
          DatabaseError(message: "An error occurred: ${error.toString()}"),
        );
      });
    } catch (e) {
      log("Error in [subscribeMembers]: $e");
      yield Left(DatabaseError(message: "Something went wrong. Try again"));
    }
  }

  @override
  Stream<Either<Failure, List<User>>> subscribeRequests(
      {required String budgetId}) async* {
    try {
      final stream = _firebaseDatabase
          .ref(FirebasePath.budgetRequestPath(budgetId))
          .onValue
          .asyncMap<Either<Failure, List<User>>>((event) async {
        try {
          List<User> members = [];
          if (event.snapshot.exists) {
            for (final member in event.snapshot.children) {
              final result = await getUserInfoByID(id: member.key.toString());
              if (result.isRight) {
                final status =
                    member.child("status").value?.toString() ?? "unknown";
                final joinedDate = DateTime.fromMillisecondsSinceEpoch(
                  int.tryParse(member.child("date").value?.toString() ?? "0") ??
                      0,
                );
                final user = result.right.copyWith(
                  date: joinedDate,
                  userStatus: status,
                );
                members.add(user);
              }
            }
          }
          return Right(members);
        } catch (e) {
          return Left(
            DatabaseError(
                message: "Error processing requests: ${e.toString()}"),
          );
        }
      });

      yield* stream.handleError((error) {
        return Left(
          DatabaseError(message: "An error occurred: ${error.toString()}"),
        );
      });
    } catch (e) {
      log("Error in [subscribeRequests]: $e");
      yield Left(DatabaseError(message: "Something went wrong. Try again"));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetInfo>>> subscribeInvitations(
      {required String userId}) async* {
    try {
      final stream = _firebaseDatabase
          .ref(FirebasePath.invitationPath(userId))
          .onValue
          .asyncMap<Either<Failure, List<BudgetInfo>>>((event) async {
        try {
          List<BudgetInfo> budgets = [];
          if (event.snapshot.exists) {
            for (final budget in event.snapshot.children) {
              final joinedDate = DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(budget.child("date").value?.toString() ?? "0") ??
                    0,
              );
              final result = await getBudgetInfo(
                budgetId: budget.key.toString(),
                date: joinedDate,
              );
              if (result.isRight && result.right != null) {
                budgets.add(result.right!);
              }
            }
          }
          return Right(budgets);
        } catch (e) {
          return Left(
            DatabaseError(message: "Error processing invites: ${e.toString()}"),
          );
        }
      });

      yield* stream.handleError((error) {
        return Left(
          DatabaseError(message: "An error occurred: ${error.toString()}"),
        );
      });
    } catch (e) {
      log("Error in [subscribeInvitations]: $e");
      yield Left(DatabaseError(message: "Something went wrong. Try again"));
    }
  }

  @override
  Stream<Either<Failure, List<BudgetInfo>>> subscribeMyInvitationRequests(
      {required String userId}) async* {
    try {
      final stream = _firebaseDatabase
          .ref(FirebasePath.userRequestPath(userId))
          .onValue
          .asyncMap<Either<Failure, List<BudgetInfo>>>((event) async {
        try {
          List<BudgetInfo> budgets = [];
          if (event.snapshot.exists) {
            for (final budget in event.snapshot.children) {
              final joinedDate = DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(budget.child("date").value?.toString() ?? "0") ??
                    0,
              );
              final result = await getBudgetInfo(
                budgetId: budget.key.toString(),
                date: joinedDate,
              );
              if (result.isRight && result.right != null) {
                budgets.add(result.right!);
              }
            }
          }
          return Right(budgets);
        } catch (e) {
          return Left(
            DatabaseError(
                message: "Error processing requests: ${e.toString()}"),
          );
        }
      });

      yield* stream.handleError((error) {
        return Left(
          DatabaseError(message: "An error occurred: ${error.toString()}"),
        );
      });
    } catch (e) {
      log("Error in [subscribeInvitations]: $e");
      yield Left(DatabaseError(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> acceptBudgetInvitation({
    required String budgetId,
    required String budgetName,
    required String userId,
    required String userName,
  }) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch.toString();

      // Add user into budget node
      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .child(userId)
          .update({
        "status": "joined",
        "date": date,
      });

      // Add budget into member joined node
      await _firebaseDatabase
          .ref(FirebasePath.joinedBudgetPath(userId))
          .child(budgetId)
          .set({
        "date": date,
      });
      // Remove request from user invitation node
      await _firebaseDatabase
          .ref(FirebasePath.invitationPath(userId))
          .child(budgetId)
          .remove();

      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .once()
          .then((event) async {
        for (final member in event.snapshot.children) {
          await _firebaseDatabase
              .ref(FirebasePath.notificationPath(member.key.toString()))
              .child(date)
              .set({
            "title": Notification.memberJoined,
            "body":
                "New member \"$userName\" has been joined to \"$budgetName\" budget ",
            "time": date,
          });
          // Toggle notification status to true
          await _firebaseDatabase
              .ref(FirebasePath.userPath(member.key.toString()))
              .update({"notification_status": true});
        }
      });

      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][acceptBudgetInvitation] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBudgetInvitation({
    required String budgetId,
    required String budgetName,
    required String userId,
    required String userName,
  }) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch.toString();

      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .child(userId)
          .remove();

      // Remove request from user invitation node
      await _firebaseDatabase
          .ref(FirebasePath.invitationPath(userId))
          .child(budgetId)
          .remove();

      await _firebaseDatabase
          .ref(FirebasePath.membersPath(budgetId))
          .once()
          .then((event) async {
        for (final member in event.snapshot.children) {
          await _firebaseDatabase
              .ref(FirebasePath.notificationPath(member.key.toString()))
              .child(date)
              .set({
            "title": Notification.requestDeclined,
            "body":
                "\"$userName\" has been declined the request to join \"$budgetName\" budget ",
            "time": date,
          });
          // Toggle notification status to true
          await _firebaseDatabase
              .ref(FirebasePath.userPath(member.key.toString()))
              .update({"notification_status": true});
        }
      });

      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][removeBudgetInvitation] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, bool>> removeMyBudgetJoinRequest({
    required String budgetId,
    required String userId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.budgetRequestPath(budgetId))
          .child(userId)
          .remove();
      await _firebaseDatabase
          .ref(FirebasePath.userRequestPath(userId))
          .child(budgetId)
          .remove();

      return const Right(true);
    } catch (e) {
      log("er:[account_fb_data_source_impl.dart][removeMyBudgetJoinRequest] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }
}
