import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final String currentExpenseId;
  final DateTime createdOn;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.currentExpenseId,
    required this.createdOn,
  });

  UserModel copyWith({
    String? profileUrl,
    String? currentExpenseId,
  }) =>
      UserModel(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profileUrl: profileUrl ?? this.profileUrl,
        currentExpenseId: currentExpenseId ?? this.currentExpenseId,
        createdOn: createdOn,
      );

  factory UserModel.fromFirebase(DataSnapshot userData) {
    return UserModel(
      uid: userData.key.toString(),
      firstName: userData.child("first_name").value.toString(),
      lastName: userData.child("last_name").value.toString(),
      email: userData.child("email").value.toString(),
      profileUrl: userData.child("profile_url").value.toString(),
      currentExpenseId: userData.child("current_expense_id").value.toString(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData.child("created_on").value.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "profile_url": profileUrl,
        "current_expense_id": currentExpenseId,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };
}
