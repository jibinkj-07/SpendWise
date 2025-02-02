import 'package:firebase_database/firebase_database.dart';

import '../../../../core/util/helper/firebase_path.dart';

class SettingsModel {
  final String currentBudget;
  final bool newNotification;

  SettingsModel({
    required this.currentBudget,
    required this.newNotification,
  });

  factory SettingsModel.fromFirebase(DataSnapshot data) {
    return SettingsModel(
        currentBudget: data.child(FirebasePath.currentBudget).value.toString(),
        newNotification:
            data.child(FirebasePath.newNotification).value.toString() == "true");
  }

  @override
  String toString() => "current Budget $currentBudget";
}
