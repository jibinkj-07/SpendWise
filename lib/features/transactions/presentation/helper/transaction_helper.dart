import '../../domain/model/transaction_model.dart';

enum TransactionFilter {
  recent,
  oldest,
  highToLow,
  lowToHigh,
}

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
      [TransactionFilter? filter] // Custom filter type
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

    // Sort the map by keys (dates) based on filter
    final sortedKeys = items.keys.toList();
    // Most recent dates first
    sortedKeys.sort((a, b) => b.compareTo(a));
    // switch (filter) {
    //   case TransactionFilter.recent:
    //     sortedKeys.sort((a, b) => b.compareTo(a)); // Most recent dates first
    //     break;
    //   case TransactionFilter.oldest:
    //     sortedKeys.sort((a, b) => a.compareTo(b)); // Oldest dates first
    //     break;
    //   default:
    //     break;
    // }

    // Rebuild the map with sorted keys
    final sortedMap = {
      for (final key in sortedKeys) key: items[key]!,
    };

    return sortedMap;
  }
}
