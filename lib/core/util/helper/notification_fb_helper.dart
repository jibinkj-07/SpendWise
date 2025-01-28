import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

import 'firebase_path.dart';

class NotificationFbHelper {
  final FirebaseDatabase _firebaseDatabase;

  NotificationFbHelper(this._firebaseDatabase);

  Future<void> sendNotification({
    required String title,
    required String body,
    required String userId,
  }) async {
    try {
      final date = DateTime.now().millisecondsSinceEpoch.toString();
      await _firebaseDatabase
          .ref(FirebasePath.notificationPath(userId))
          .child(date)
          .set({
        "title": title,
        "body": body,
        "time": date,
      });
      await toggleReadStatus(userId, true);
    } catch (e) {
      log("er: [notification_fb_helper.dart][sendNotification] $e");
    }
  }

  Future<void> toggleReadStatus(String userId, bool status) async {
    await _firebaseDatabase
        .ref(FirebasePath.userPath(userId))
        .update({FirebasePath.notificationStatusNode: status});
  }
}
