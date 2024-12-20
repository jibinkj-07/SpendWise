import 'package:flutter/material.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/domain/model/transaction_model.dart';

/// @author : Jibin K John
/// @date   : 18/12/2024
/// @time   : 22:48:41

class TransactionEntryScreen extends StatefulWidget {
  final TransactionModel? transactionModel;

  const TransactionEntryScreen({super.key, this.transactionModel});

  @override
  State<TransactionEntryScreen> createState() => _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Transaction"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
