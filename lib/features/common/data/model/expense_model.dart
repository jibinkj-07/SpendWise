import 'package:firebase_database/firebase_database.dart';

class ExpenseModel {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final List<String> documents;
  final String addedBy;
  final String color;

  ExpenseModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.documents,
    required this.addedBy,
    required this.color,
  });

  ExpenseModel copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? description,
    String? addedBy,
    List<String>? documents,
    String? color,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        addedBy: addedBy ?? this.addedBy,
        documents: documents ?? this.documents,
        color: color ?? this.color,
      );

  factory ExpenseModel.fromFirebase(DataSnapshot expenseData) {
    final documents = expenseData.child("documents").exists
        ? expenseData.child("documents").value as List<dynamic>
        : [];
    return ExpenseModel(
      id: expenseData.child("id").value.toString(),
      date: DateTime.parse(expenseData.child("date").value.toString()),
      amount: double.parse(expenseData.child("amount").value.toString()),
      description: expenseData.child("description").value.toString(),
      documents: documents.map((e) => e.toString()).toList(),
      addedBy: expenseData.child("added_by").value.toString(),
      color: expenseData.child("color").value.toString(),
    );
  }

  Map<String, dynamic> toFirebaseJson() => {
        "${date.year}": {
          "${date.month}": {
            "${date.millisecondsSinceEpoch}": {
              "id": id,
              "date": date.toString(),
              "amount": amount,
              "description": description,
              "documents": documents,
              "added_by": addedBy,
              "color": color,
            }
          },
        },
      };
}
