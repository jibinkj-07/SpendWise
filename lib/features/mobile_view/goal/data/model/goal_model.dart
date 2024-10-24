import 'package:my_budget/features/mobile_view/goal/data/model/goal_transaction_model.dart';

class GoalModel {
  final String id;

  final String title;
  final double budget;
  final DateTime createdOn;
  final List<GoalTransactionModel> transactions;

  GoalModel({
    required this.id,
    required this.budget,
    required this.createdOn,
    required this.title,
    required this.transactions,
  });

  GoalModel copyWith({
    String? id,
    String? title,
    double? budget,
    DateTime? createdOn,
    List<GoalTransactionModel>? transactions,
  }) =>
      GoalModel(
        id: id ?? this.id,
        createdOn: createdOn ?? this.createdOn,
        budget: budget ?? this.budget,
        title: title ?? this.title,
        transactions: transactions ?? this.transactions,
      );

  double totalTransactionSum() => transactions.fold(
        0,
        (prev, element) => prev + element.amount,
      );

  Map<String, dynamic> toFirebaseJson() => {
        id: {
          "title": title,
          "budget": budget,
          "transactions": [],
          "created_on": createdOn.millisecondsSinceEpoch.toString(),
        },
      };
}
