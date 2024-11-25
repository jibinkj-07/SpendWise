import 'package:firebase_database/firebase_database.dart';

import 'goal_trans_model.dart';

class GoalModel {
  final String id;
  final String name;
  final double amount;
  final DateTime createdOn;
  final List<GoalTransModel> history;

  GoalModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdOn,
    required this.history,
  });

  GoalModel copyWith({
    String? name,
    double? amount,
    DateTime? createdOn,
    List<GoalTransModel>? history,
  }) =>
      GoalModel(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        createdOn: createdOn ?? this.createdOn,
        history: history ?? this.history,
      );

  factory GoalModel.fromFirebase(DataSnapshot data) {
    List<GoalTransModel> history = [];
    for (final item in data.child("history").children) {
      history.add(GoalTransModel.fromFirebase(item));
    }
    return GoalModel(
      id: data.key.toString(),
      name: data.child("name").value.toString(),
      amount: double.parse(data.child("amount").value.toString()),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(
          data.child("created_on").value.toString(),
        ),
      ),
      history: history,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };
}
