import 'package:firebase_database/firebase_database.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';

class GoalTransactionModel {
  final String id;
  final UserModel addedBy;
  final DateTime createdOn;
  final double amount;

  GoalTransactionModel({
    required this.id,
    required this.addedBy,
    required this.createdOn,
    required this.amount,
  });

  GoalTransactionModel copyWith({
    String? id,
    UserModel? addedBy,
    double? amount,
    DateTime? createdOn,
  }) =>
      GoalTransactionModel(
        id: id ?? this.id,
        createdOn: createdOn ?? this.createdOn,
        addedBy: addedBy ?? this.addedBy,
        amount: amount ?? this.amount,
      );

  factory GoalTransactionModel.fromFirebase(DataSnapshot transactionData, UserModel addedBy) {
    return GoalTransactionModel(
        id: transactionData.key.toString(),
        amount: double.parse(transactionData.child("amount").value.toString()),
        addedBy: addedBy,
        createdOn: DateTime.fromMillisecondsSinceEpoch(
            int.parse(transactionData.child("created_on").value.toString())));
  }

  Map<String, dynamic> toFirebaseJson() => {
    id: {
      "amount": amount,
      "user_id": addedBy.uid,
      "created_on": createdOn.millisecondsSinceEpoch.toString(),
    },
  };
}
