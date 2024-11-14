sealed class FirebasePath {
  static final String userNode = "users";
  static final String expenseNode = "expenses";
  static final String categoryNode = "categories";
  static final String transactionNode = "transactions";

  static String categoryPath(String expenseId, String catId) =>
      "$expenseNode/$expenseId/$categoryNode/$catId";

  static String transactionPath(String expenseId, String transId) =>
      "$expenseNode/$expenseId/$transactionNode/$transId";

  static String expensePath(String expenseId) => "$expenseNode/$expenseId";
}
