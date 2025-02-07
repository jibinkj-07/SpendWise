import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../../core/util/helper/notification_fb_helper.dart';
import '../model/notification_model.dart';

abstract class NotificationDataSource {
  Stream<Either<Failure, List<NotificationModel>>> subscribeNotification({
    required String userId,
  });

  Future<Either<Failure, bool>> deleteNotification({
    required String userId,
    required String notificationId,
  });

  Future<Either<Failure, bool>> clearAllNotification({required String userId});
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final FirebaseDatabase _firebaseDatabase;
  final NotificationFbHelper _notificationFbHelper;

  NotificationDataSourceImpl(
    this._firebaseDatabase,
    this._notificationFbHelper,
  );

  @override
  Future<Either<Failure, bool>> clearAllNotification({
    required String userId,
  }) async {
    try {
      await _firebaseDatabase.ref(FirebasePath.notifications(userId)).remove();
      return const Right(true);
    } catch (e) {
      log("er: [notification_fb_data_source.dart][clearAllNotification] $e");
      return Left(DatabaseError(message: 'Something went wrong.'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await _firebaseDatabase
          .ref(FirebasePath.notifications(userId))
          .child(notificationId)
          .remove();
      return const Right(true);
    } catch (e) {
      log("er: [notification_fb_data_source.dart][clearAllNotification] $e");
      return Left(DatabaseError(message: 'Something went wrong.'));
    }
  }

  @override
  Stream<Either<Failure, List<NotificationModel>>> subscribeNotification({
    required String userId,
  }) async* {
    // change user notification unread count back to 0
    // Means user read notifications
    await _notificationFbHelper.updateUnreadCount(userId, 0);
    try {
      yield* _firebaseDatabase
          .ref(FirebasePath.notifications(userId))
          .onValue
          .map<Either<Failure, List<NotificationModel>>>((event) {
        if (event.snapshot.exists) {
          List<NotificationModel> notifications = [];
          for (final notification in event.snapshot.children) {
            notifications.add(NotificationModel.fromFirebase(notification));
          }
          notifications.sort((a, b) => b.date.compareTo(a.date));
          return Right(notifications);
        }
        return Left(Failure(message: "No notifications"));
      });
    } catch (e) {
      log("er: [notification_fb_data_source.dart][clearAllNotification] $e");
      yield Left(DatabaseError(message: 'Something went wrong.'));
    }
  }
}
