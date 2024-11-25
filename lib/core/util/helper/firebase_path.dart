sealed class FirebasePath {
  static final String userNode = "users";
  static final String budgetNode = "budgets";
  static final String categoryNode = "categories";
  static final String transactionNode = "transactions";

  static String categoryPath(String budgetId, String catId) =>
      "$budgetNode/$budgetId/$categoryNode/$catId";

  static String userPath(String userId) => "$userNode/$userId";

  static String invitationPath(String userId) =>
      "$userNode/$userId/invitations";

  static String transactionPath(String budgetId, String transId) =>
      "$budgetNode/$budgetId/$transactionNode/$transId";

  static String budgetPath(String budgetId) => "$budgetNode/$budgetId";

  static String goalPath(String budgetId, String goalId) =>
      "$budgetNode/$budgetId/goals/$goalId";
}
