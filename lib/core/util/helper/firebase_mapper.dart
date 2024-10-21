sealed class FirebaseMapper {
  static String userNode = "user";
  static String expenseNode = "expense";

  static String userPath(String id) => "$userNode/$id";
  static String expensePath(String adminId) => "$expenseNode/$adminId";
}
