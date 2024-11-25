import 'package:firebase_database/firebase_database.dart';

class GoalTransModel {
  final String id;
  final DateTime date;
  final double amount;
  final String createdUserId;
  final String accountType;

  GoalTransModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.createdUserId,
    required this.accountType,
  });

  GoalTransModel copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? createdUserId,
    String? accountType,
  }) =>
      GoalTransModel(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        accountType: accountType ?? this.accountType,
        createdUserId: createdUserId ?? this.createdUserId,
      );

  factory GoalTransModel.fromFirebase(DataSnapshot data) {
    return GoalTransModel(
      id: data.key.toString(),
      amount: double.parse(data.child("amount").value.toString()),
      date: DateTime.fromMillisecondsSinceEpoch(
        int.parse(data.child("date").value.toString()),
      ),
      accountType: data.child("account_type").value.toString(),
      createdUserId: data.child("created_by").value.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date.millisecondsSinceEpoch.toString(),
        "account_type": accountType,
        "created_by": createdUserId,
      };
}
