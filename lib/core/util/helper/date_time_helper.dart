sealed class DateTimeHelper {
  static DateTime getDateTimeFromMilli(String milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(milliseconds));
}
