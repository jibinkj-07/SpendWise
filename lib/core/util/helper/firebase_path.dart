sealed class FirebasePath {
  static final String userNode = "users";
  static final String budgetNode = "budgets";
  static final String categoryNode = "categories";
  static final String memberNode = "members";
  static final String requestNode = "requests";
  static final String transactionNode = "transactions";
  static final String notificationStatusNode = "new_notification";

  static String categoryPath(String budgetId, String catId) =>
      "$budgetNode/$budgetId/$categoryNode/$catId";

  static String membersPath(String budgetId) =>
      "$budgetNode/$budgetId/$memberNode";

  static String budgetRequestPath(String budgetId) =>
      "$budgetNode/$budgetId/$requestNode";

  static String userDetailPath(String userId) => "$userNode/$userId/details";
  static String userPath(String userId) => "$userNode/$userId";
  static String userNotificationPath(String userId) => "$userNode/$userId/$notificationStatusNode";

  static String userRequestPath(String userId) =>
      "$userNode/$userId/$requestNode";

  static String joinedBudgetPath(String userId) => "$userNode/$userId/joined";

  static String invitationPath(String userId) =>
      "$userNode/$userId/invitations";

  static String transactionPath(String budgetId) =>
      "$budgetNode/$budgetId/$transactionNode";

  static String budgetPath(String budgetId) => "$budgetNode/$budgetId";

  static String budgetDetailPath(String budgetId) =>
      "$budgetNode/$budgetId/details";



  static String notificationPath(String userId) => "notifications/$userId";
}
