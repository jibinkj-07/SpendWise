import 'package:firebase_database/firebase_database.dart';

class ExpenseParticipation {
  final String adminId;
  final String expenseId;
  final DateTime date;

  ExpenseParticipation({
    required this.adminId,
    required this.expenseId,
    required this.date,
  });

  factory ExpenseParticipation.fromFirebase(
    DataSnapshot data,
    bool isJoinedPath,
  ) =>
      ExpenseParticipation(
        adminId: data.child("admin").value.toString(),
        expenseId: data.key.toString(),
        date: DateTime.fromMillisecondsSinceEpoch(
          int.parse(
            data.child(isJoinedPath ? "joined_on" : "invited_on").value.toString(),
          ),
        ),
      );

  Map<String, dynamic> toJson(bool isJoinedPath) => {
        expenseId: {
          "admin": adminId,
          isJoinedPath ? "joined_on" : "invited_on":
              date.millisecondsSinceEpoch.toString(),
        }
      };
}
