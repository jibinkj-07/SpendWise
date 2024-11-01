import 'package:firebase_database/firebase_database.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String adminId;
  final DateTime? addedOn;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.adminId,
    this.addedOn,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? adminId,
    DateTime? addedOn,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        adminId: adminId ?? this.adminId,
        addedOn: addedOn ?? this.addedOn,
      );

  factory UserModel.fromFirebase(DataSnapshot userData, String uid) {
    return UserModel(
      uid: uid,
      name: userData.child("name").value.toString(),
      email: userData.child("email").value.toString(),
      adminId: userData.child("admin_id").value.toString(),
    );
  }

  Map<String, dynamic> toFirebaseJson() => {
        uid: {
          "name": name,
          "email": email,
          "admin_id": adminId,
        }
      };
}
