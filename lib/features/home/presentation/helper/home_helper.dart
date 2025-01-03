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
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../../budget/presentation/bloc/category_view_bloc.dart';
import '../../../transactions/domain/model/transaction_model.dart';
import '../../../transactions/presentation/bloc/month_trans_view_bloc.dart';
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

void loadBudget(BuildContext context, [String? budgetId]) {
  String? currentBudget = budgetId;
  final authBloc = context.read<AuthBloc>();
  if (currentBudget == null && authBloc.state is Authenticated) {
    currentBudget = (authBloc.state as Authenticated).user.selectedBudget;
  }

  // this only subscribe to budget basic details node
  context
      .read<BudgetViewBloc>()
      .add(SubscribeBudget(budgetId: currentBudget ?? ""));
  context
      .read<CategoryViewBloc>()
      .add(SubscribeCategory(budgetId: currentBudget ?? ""));
  context.read<MonthTransViewBloc>().add(
        SubscribeMonthView(
          budgetId: currentBudget ?? "",
          date: DateTime.now(),
        ),
      );
}

List<WeeklyChartData> generateWeekChartData(
  List<TransactionModel> transactions,
) =>
    List.generate(
      7,
      (index) {
        final today = DateTime.now();
        DateTime day;

        if (today.day < 8) {
          // Generate dates from the 1st to the 7th of the current month
          day = DateTime(today.year, today.month, index + 1);
        } else {
          // Generate dates for the last 7 days, including today
          day = today.subtract(Duration(days: 6 - index));
        }

        return WeeklyChartData(
          formatChartDate(day),
          TransactionHelper.findDayWiseTotal(transactions, day),
          isToday(day) ? AppConfig.focusColor : AppConfig.primaryColor,
          isToday(day),
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

  if (now.day < 8) {
    // Collect transactions from the 1st to the 7th of the current month
    for (int day = 1; day <= 7; day++) {
      String key = '${now.year}-${now.month}-$day';
      if (transactionMap.containsKey(key)) {
        data.addAll(transactionMap[key]!);
      }
    }
  } else {
    // Collect transactions from the past 7 days, including today
    for (int i = 6; i >= 0; i--) {
      DateTime day = now.subtract(Duration(days: i));
      String key = '${day.year}-${day.month}-${day.day}';
      if (transactionMap.containsKey(key)) {
        data.addAll(transactionMap[key]!);
      }
    }
  }

  return data;
}

bool isToday(DateTime date) {
  final today = DateTime.now();
  return date.year == today.year &&
      date.month == today.month &&
      date.day == today.day;
}

String formatChartDate(DateTime date) =>
    "${DateFormat.E().format(date)}\n${DateFormat.d().format(date)}";
