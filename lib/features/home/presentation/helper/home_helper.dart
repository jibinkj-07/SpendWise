import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/chart_helpers.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../budget/presentation/bloc/budget_bloc.dart';
import '../../../budget/presentation/bloc/category_bloc.dart';
import '../bloc/home_transaction_bloc.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';

class HomeHelper {
  final FirebaseDatabase _firebaseDatabase;

  HomeHelper(this._firebaseDatabase);

  Future<BudgetModel?> getBudgetDetail(String id) async {
    try {
      final result =
          await _firebaseDatabase.ref(FirebasePath.budgetDetailPath(id)).once();
      if (result.snapshot.exists) {
        return BudgetModel.fromFirebase(result.snapshot, id);
      }
    } catch (e) {
      log("er: [home_helper.dart][getBudgetDetail] $e");
    }
    return null;
  }
}

void initBudgetData(BuildContext context, [String? budgetId]) {
  String currentBudget = "";
  final authBloc = context.read<AuthBloc>();
  if (authBloc.state is Authenticated) {
    currentBudget = (authBloc.state as Authenticated).user.selectedBudget;
  }

  // this only subscribe to budget basic details node
  context
      .read<BudgetBloc>()
      .add(SubscribeBudget(budgetId: budgetId ?? currentBudget));
  context
      .read<CategoryBloc>()
      .add(SubscribeCategory(budgetId: budgetId ?? currentBudget));
  context.read<HomeTransactionBloc>().add(
        SubscribeTransaction(
          budgetId: budgetId ?? currentBudget,
          // startDate: DateTime(date.year, date.month, 1),
          // endDate: DateTime(date.year, date.month + 1, 0), // End of the month
        ),
      );
}

List<WeeklyChartData> generateWeekChartData(
  List<TransactionModel> transactions,
) =>
    List.generate(
      7,
      (index) {
        final day = DateTime.now().subtract(
            Duration(days: 6 - index)); // Generate 7 days ending with today

        return WeeklyChartData(
          "${DateFormat.E().format(day)}\n${DateFormat.d().format(day)}",
          TransactionHelper.findDayWiseTotal(transactions, day),
          index == 6 ? AppConfig.focusColor : AppConfig.primaryColor,
          index == 6,
        );
      },
    );

List<TransactionModel> generateWeekTransactions(
  List<TransactionModel> transactions,
) {
  Map<String, List<TransactionModel>> transactionMap = {};

  for (var transaction in transactions) {
    final date =
        '${transaction.date.year}-${transaction.date.month}-${transaction.date.day}';
    if (transactionMap.containsKey(date)) {
      transactionMap[date]!.add(transaction);
    } else {
      transactionMap[date] = [transaction];
    }
  }

  List<TransactionModel> data = [];
  DateTime now = DateTime.now();

  for (int i = 6; i >= 0; i--) {
    DateTime day = now.subtract(Duration(days: i));
    String key = '${day.year}-${day.month}-${day.day}';

    if (transactionMap.containsKey(key)) {
      data.addAll(transactionMap[key]!);
    }
  }

  return data;
}
