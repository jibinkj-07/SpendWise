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

  static TransactionModel findGreatestTransaction(
    List<TransactionModel> transactions,
  ) =>
      transactions.reduce(
        (current, next) => current.amount > next.amount ? current : next,
      );

  static Map<DateTime, List<TransactionModel>> groupByDate(
    List<TransactionModel> transactions,
    bool isAscend,
  ) {
    // Group transactions by date
    Map<DateTime, List<TransactionModel>> items = {};

    for (final trans in transactions) {
      final date = DateTime(
        trans.date.year,
        trans.date.month,
        trans.date.day,
      );
      if (items.containsKey(date)) {
        items[date]!.add(trans);
      } else {
        items[date] = [trans];
      }
    }

    // Sort the map by keys (dates) in ascending or descending order
    final sortedKeys = items.keys.toList()
      ..sort((a, b) => isAscend ? a.compareTo(b) : b.compareTo(a));

    // Rebuild the map with sorted keys
    final sortedMap = {
      for (final key in sortedKeys) key: items[key]!,
    };

    return sortedMap;
  }
}
