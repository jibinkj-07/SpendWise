sealed class FirebaseMapper {
  static String userNode = "user";

  static String userPath(String id) => "$userNode/$id";

  static String expensePath(String adminId) => "data/$adminId/expense";

  static String categoryPath(String adminId) => "data/$adminId/category";

  static String memberPath(String adminId) => "$userNode/$adminId/members";

  static String goalPath(String adminId) => "data/$adminId/goals";

  static String goalTransactionPath(String adminId, String goalId) =>
      "data/$adminId/goals/$goalId/transactions";
}
