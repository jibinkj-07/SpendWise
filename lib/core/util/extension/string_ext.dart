extension FirstLetterUppercase on String {
  String firstLetterToUpperCase() =>
      "${substring(0, 1).toUpperCase()}${substring(1)}";
}
