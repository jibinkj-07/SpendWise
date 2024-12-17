import 'package:flutter/material.dart';

import '../../../budget/domain/model/transaction_model.dart';

/// @author : Jibin K John
/// @date   : 16/12/2024
/// @time   : 20:24:26

class TransactionListTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionListTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(transaction.title),
    );
  }
}
