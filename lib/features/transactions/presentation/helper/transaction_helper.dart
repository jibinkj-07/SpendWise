import '../../../budget/domain/model/transaction_model.dart';

sealed class TransactionHelper {
  static double findTotal(List<TransactionModel> transactions) =>
      transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);

  static double findDayWiseTotal(
    List<TransactionModel> transactions,
    DateTime day,
  ) {
    final trans = transactions
        .where((item) =>
            (item.date.year == day.year) &&
            (item.date.month == day.month) &&
            (item.date.day == day.day))
        .toList();
    return trans.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }
}
