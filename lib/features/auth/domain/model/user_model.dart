
import 'package:firebase_database/firebase_database.dart';

import 'expense_participation.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<ExpenseParticipation> joinedExpenses;
  final List<ExpenseParticipation> invitedExpenses;
  final DateTime createdOn;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.createdOn,
    required this.joinedExpenses,
    required this.invitedExpenses,
  });

  factory UserModel.fromFirebase(DataSnapshot userData) {
    List<ExpenseParticipation> joinedExpenses = [];
    List<ExpenseParticipation> invitedExpenses = [];
    for (final joined in userData.child("joined_expenses").children) {
      joinedExpenses.add(ExpenseParticipation.fromFirebase(joined, true));
    }
    for (final invited in userData.child("invited_expenses").children) {
      joinedExpenses.add(ExpenseParticipation.fromFirebase(invited, false));
    }
    return UserModel(
      uid: userData.key.toString(),
      firstName: userData.child("first_name").value.toString(),
      lastName: userData.child("last_name").value.toString(),
      email: userData.child("email").value.toString(),
      profileUrl: userData.child("profile_url").value.toString(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData.child("created_on").value.toString()),
      ),
      joinedExpenses: joinedExpenses,
      invitedExpenses: invitedExpenses,
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "profile_url": profileUrl,
        "joined_expenses":
            joinedExpenses.map((item) => item.toJson(true)).toList(),
        "invited_expenses":
            invitedExpenses.map((item) => item.toJson(false)).toList().toList(),
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };
}
