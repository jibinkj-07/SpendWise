import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  final String selectedBudget;
  final bool notificationStatus;
  final DateTime createdOn;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.selectedBudget,
    required this.notificationStatus,
    required this.createdOn,
  });

  factory UserModel.fromFirebase(DataSnapshot userData) {
    // If user logging with google there might be a chance to
    // not creating selected node under user detail
    final budget = userData.child("selected").exists
        ? userData.child("selected").value.toString()
        : "";
    return UserModel(
      uid: userData.key.toString(),
      name: userData.child("name").value.toString(),
      email: userData.child("email").value.toString(),
      profileUrl: userData.child("profile_url").value.toString(),
      notificationStatus:
          userData.child("notification_status").value.toString() == "true",
      selectedBudget: budget,
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData.child("created_on").value.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "profile_url": profileUrl,
        "selected": selectedBudget,
        "notification_status": notificationStatus,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };

  @override
  String toString() =>
      "UID $uid Name $name Email $email\nURL $profileUrl Selected $selectedBudget";
}
