import 'package:flutter/material.dart';

import '../../../budget/domain/model/category_model.dart';
import '../../domain/model/transaction_model.dart';

/// @author : Jibin K John
/// @date   : 29/12/2024
/// @time   : 16:35:03

class TransactionDetailView extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel category;

  const TransactionDetailView({
    super.key,
    required this.transaction,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("TransactionDetailView"),
        centerTitle: true,
      ),
      body: Center(child: Text("TransactionDetailView")),
    );
  }
}
