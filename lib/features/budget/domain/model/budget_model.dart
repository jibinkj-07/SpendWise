import 'package:firebase_database/firebase_database.dart';

class BudgetModel {
  final String id;
  final String name;
  final String currencySymbol;
  final String currency;
  final String admin;
  final DateTime createdOn;

  BudgetModel({
    required this.id,
    required this.name,
    required this.currencySymbol,
    required this.currency,
    required this.admin,
    required this.createdOn,
  });

  factory BudgetModel.fromFirebase(DataSnapshot data, String id) {
    return BudgetModel(
      id: id,
      name: data.child("name").value.toString(),
      currencySymbol: data.child("currency_symbol").value.toString(),
      currency: data.child("currency").value.toString(),
      admin: data.child("admin").value.toString(),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(data.child("created_on").value.toString()),
      ),
    );
  }

  factory BudgetModel.dummy() {
    return BudgetModel(
      id: "",
      name: "",
      currencySymbol: "",
      currency: "",
      admin: "",
      createdOn: DateTime.now(),
    );
  }
}
