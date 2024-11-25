import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileUrl;
  final String selectedBudget;
  final DateTime createdOn;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileUrl,
    required this.selectedBudget,
    required this.createdOn,
  });

  UserModel copyWith({
    String? profileUrl,
    String? selectedBudget,
  }) =>
      UserModel(
        uid: uid,
        name: name,
        email: email,
        profileUrl: profileUrl ?? this.profileUrl,
        selectedBudget: selectedBudget ?? this.selectedBudget,
        createdOn: createdOn,
      );

  factory UserModel.fromFirebase(DataSnapshot userData) {
    return UserModel(
      uid: userData.key.toString(),
      name: userData.child("name").value.toString(),
      email: userData.child("email").value.toString(),
      profileUrl: userData.child("profile_url").value.toString(),
      selectedBudget: userData.child("selected").value.toString(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData.child("created_on").value.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "profile_url": profileUrl,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };
}
