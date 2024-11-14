import 'package:firebase_database/firebase_database.dart';

import 'category_model.dart';
import 'transaction_model.dart';

class ExpenseModel {
  final String id;
  final String name;
  final String adminId;
  final DateTime createdOn;
  final List<String> members;
  final List<String> invitedUsers;
  final List<CategoryModel> categories;
  final List<TransactionModel> transactions;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.adminId,
    required this.createdOn,
    required this.members,
    required this.invitedUsers,
    required this.categories,
    required this.transactions,
  });

  ExpenseModel copyWith({
    String? id,
    String? name,
    String? adminId,
    DateTime? createdOn,
    List<String>? members,
    List<String>? invitedUsers,
    List<CategoryModel>? categories,
    List<TransactionModel>? transactions,
  }) =>
      ExpenseModel(
        id: id ?? this.id,
        name: name ?? this.name,
        adminId: adminId ?? this.adminId,
        createdOn: createdOn ?? this.createdOn,
        members: members ?? this.members,
        invitedUsers: invitedUsers ?? this.invitedUsers,
        categories: categories ?? this.categories,
        transactions: transactions ?? this.transactions,
      );

  factory ExpenseModel.fromFirebase(DataSnapshot expenseData) {
    List<CategoryModel> categories = [];
    List<TransactionModel> transactions = [];
    final members = expenseData.child("members").exists
        ? expenseData.child("members").value as List<dynamic>
        : [];
    final users = expenseData.child("invited_users").exists
        ? expenseData.child("invited_users").value as List<dynamic>
        : [];

    for (final cat in expenseData.child("categories").children) {
      categories.add(CategoryModel.fromFirebase(cat));
    }
    for (final trans in expenseData.child("transactions").children) {
      transactions.add(TransactionModel.fromFirebase(trans));
    }

    return ExpenseModel(
      id: expenseData.key.toString(),
      name: expenseData.child("name").toString(),
      adminId: expenseData.child("admin_id").toString(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(expenseData.child("created_on").toString()),
      ),
      members: members.map((e) => e.toString()).toList(),
      invitedUsers: users.map((e) => e.toString()).toList(),
      categories: categories,
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "admin_id": adminId,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
        "members": members,
        "invited_users": invitedUsers,
        "categories": categories.map((item) => item.toJson()).toList(),
        "transactions": transactions.map((item) => item.toJson()).toList(),
      };
}
