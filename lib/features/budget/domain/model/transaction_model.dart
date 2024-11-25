import 'package:firebase_database/firebase_database.dart';

class TransactionModel {
  final String id;
  final DateTime date;
  final double amount;
  final String title;
  final String description;
  final String docUrl;
  final String categoryId;
  final String createdUserId;
  final String accountType;

  TransactionModel({
    required this.id,
    required this.date,
    required this.amount,
    required this.title,
    required this.docUrl,
    required this.description,
    required this.categoryId,
    required this.createdUserId,
    required this.accountType,
  });

  TransactionModel copyWith({

    DateTime? date,
    double? amount,
    String? title,
    String? description,
    String? categoryId,
    String? docUrl,
    String? createdUserId,
    String? accountType,
  }) =>
      TransactionModel(
        id: id,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        title: title ?? this.title,
        docUrl: docUrl ?? this.docUrl,
        description: description ?? this.description,
        categoryId: categoryId ?? this.categoryId,
        accountType: accountType ?? this.accountType,
        createdUserId: createdUserId ?? this.createdUserId,
      );

  factory TransactionModel.fromFirebase(DataSnapshot transData) {
    return TransactionModel(
      id: transData.key.toString(),
      title: transData.child("title").value.toString(),
      amount: double.parse(transData.child("amount").value.toString()),
      date: DateTime.fromMillisecondsSinceEpoch(
        int.parse(transData.child("date").value.toString()),
      ),
      description: transData.child("description").value.toString(),
      docUrl: transData.child("doc_url").value.toString(),
      categoryId: transData.child("category_id").value.toString(),
      accountType: transData.child("account_type").value.toString(),
      createdUserId: transData.child("created_userid").value.toString(),
    );
  }

  Map<String, dynamic> toJson(String url) => {
        "title": title,
        "amount": amount,
        "date": date.millisecondsSinceEpoch.toString(),
        "doc_url": docUrl,
        "description": description,
        "category_id": categoryId,
        "account_type": accountType,
        "created_userid": createdUserId,
      };
}
