import 'package:firebase_database/firebase_database.dart';
import 'package:my_budget/features/common/data/model/user_model.dart';

class ExpenseModel {
  final String id;
  final DateTime date;
  final double amount;
  final String title;
  final String description;
  final List<String> documents;
  final UserModel createdUser;

  ExpenseModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.title,
    required this.description,
    required this.documents,
    required this.createdUser,
  });

  ExpenseModel copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? description,
    UserModel? createdUser,
    List<String>? documents,
    String? title,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        createdUser: createdUser ?? this.createdUser,
        documents: documents ?? this.documents,
        title: title ?? this.title,
      );

  factory ExpenseModel.fromFirebase(
      DataSnapshot expenseData, UserModel createdUser) {
    final documents = expenseData.child("documents").exists
        ? expenseData.child("documents").value as List<dynamic>
        : [];
    return ExpenseModel(
      id: expenseData.child("id").value.toString(),
      date: DateTime.parse(expenseData.child("date").value.toString()),
      amount: double.parse(expenseData.child("amount").value.toString()),
      description: expenseData.child("description").value.toString(),
      documents: documents.map((e) => e.toString()).toList(),
      createdUser: createdUser,
      title: expenseData.child("title").value.toString(),
    );
  }

  Map<String, dynamic> toFirebaseJson(List<String> urls) => {
        "${date.year}": {
          "${date.month}": {
            id: {
              "id": id,
              "date": date.toString(),
              "amount": amount,
              "description": description,
              "documents": urls,
              "created_by": createdUser.uid,
            },
          },
        },
      };
}
