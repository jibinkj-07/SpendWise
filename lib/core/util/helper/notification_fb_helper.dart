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
          .ref(FirebasePath.notifications(userId))
          .child(date)
          .set({
        "title": title,
        "body": body,
        "time": date,
      });
      await updateUnreadCount(userId);
    } catch (e) {
      log("er: [notification_fb_helper.dart][sendNotification] $e");
    }
  }

  Future<void> updateUnreadCount(String userId, [int? count]) async {
    int value = count ?? 1;
    // Getting the current count
    if (count == null) {
      await _firebaseDatabase
          .ref(FirebasePath.userSettings(userId))
          .child(FirebasePath.unreadNotification)
          .once()
          .then((e) {
        if (e.snapshot.exists) {
          value = int.parse(e.snapshot.value.toString()) + 1;
        }
      });
    }

    // Update the new count
    await _firebaseDatabase
        .ref(FirebasePath.userSettings(userId))
        .update({FirebasePath.unreadNotification: value});
  }
}
