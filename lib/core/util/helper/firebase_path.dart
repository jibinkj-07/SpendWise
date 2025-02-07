sealed class FirebasePath {
  // Nodes
  static const String _users = "users";
  static const String _usersMeta = "users_meta";
  static const String _currentBudget = "current_budget";
  static const String _budgets = "budgets";
  static const String _categories = "categories";
  static const String _members = "members";
  static const String _requests = "requests";
  static const String _transactions = "transactions";
  static const String _unreadNotification = "unread_notifications";
  static const String _settings = "settings";

  // Nodes getters
  static String get usersNode => _users;

  static String get usersMetaNode => _usersMeta;

  static String get unreadNotification => _unreadNotification;

  static String get currentBudget => _currentBudget;

  // Paths
  static String category(String budgetId, String categoryId) =>
      "$_budgets/$budgetId/$_categories/$categoryId";

  static String members(String budgetId) => "$_budgets/$budgetId/$_members";

  static String budgetRequests(String budgetId) =>
      "$_budgets/$budgetId/$_requests";

  static String userDetails(String userId) => "$_users/$userId/details";

  static String usersMeta(String userId) => "$_usersMeta/$userId";

  static String user(String userId) => "$_users/$userId";

  static String userSettings(String userId) => "$_users/$userId/$_settings";

  static String userRequests(String userId) => "$_users/$userId/$_requests";

  static String joinedBudgets(String userId) => "$_users/$userId/joined";

  static String invitations(String userId) => "$_users/$userId/invitations";

  static String transactions(String budgetId) =>
      "$_budgets/$budgetId/$_transactions";

  static String budget(String budgetId) => "$_budgets/$budgetId";

  static String budgetDetails(String budgetId) => "$_budgets/$budgetId/details";

  static String notifications(String userId) => "notifications/$userId";
}
