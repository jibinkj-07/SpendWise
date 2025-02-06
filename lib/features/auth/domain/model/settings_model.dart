import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/helper/firebase_path.dart';

class SettingsModel {
  final String currentBudget;
  final int unreadNotifications;

  SettingsModel({
    required this.currentBudget,
    required this.unreadNotifications,
  });

  factory SettingsModel.fromFirebase(DataSnapshot data) {
    return SettingsModel(
        currentBudget: data.child(FirebasePath.currentBudget).value.toString(),
        unreadNotifications: int.parse(
            data.child(FirebasePath.unreadNotification).value.toString()));
  }

  @override
  String toString() => "current Budget $currentBudget";
}
