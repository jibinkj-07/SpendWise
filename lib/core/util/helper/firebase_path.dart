sealed class FirebasePath {
  // Nodes
  static const String _users = "users";
  static const String _budgets = "_budgets";
  static const String _categories = "_categories";
  static const String _members = "members";
  static const String _requests = "requests";
  static const String _transactions = "transactions";
  static const String _newNotification = "new_notification";
  static const String _settings = "settings";

  // Nodes getters
  static String get usersNode => _users;
  static String get newNotification => _newNotification;

  // Paths
  static String category(String budgetId, String categoryId) =>
      "$_budgets/$budgetId/$_categories/$categoryId";

  static String members(String budgetId) => "$_budgets/$budgetId/$_members";

  static String budgetRequests(String budgetId) =>
      "$_budgets/$budgetId/$_requests";

  static String userDetails(String userId) => "$_users/$userId/details";

  static String user(String userId) => "$_users/$userId";

  static String userSettings(String userId) =>
      "$_users/$userId/$_settings";

  static String userRequests(String userId) => "$_users/$userId/$_requests";

  static String joinedBudgets(String userId) => "$_users/$userId/joined";

  static String invitations(String userId) => "$_users/$userId/invitations";

  static String transactions(String budgetId) =>
      "$_budgets/$budgetId/$_transactions";

  static String budget(String budgetId) => "$_budgets/$budgetId";

  static String budgetDetails(String budgetId) => "$_budgets/$budgetId/details";

  static String notifications(String userId) => "notifications/$userId";
}
