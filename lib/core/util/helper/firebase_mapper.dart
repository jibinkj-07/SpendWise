sealed class FirebaseMapper {
  static String userNode = "user";

  static String userPath(String id) => "$userNode/$id";

  static String expensePath(String adminId) => "data/$adminId/expense";

  static String categoryPath(String adminId) => "data/$adminId/category";
}
