class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String profileUrl;
  final List<String> joinedExpenses;
  final List<String> pendingExpenses;
  final DateTime createOn;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileUrl,
    required this.createOn,
    required this.joinedExpenses,
    required this.pendingExpenses,
  });

  factory UserModel.fromFirebase(
    Map<String, dynamic> userData,
    String uid,
  ) {
    return UserModel(
      uid: uid,
      firstName: userData["first_name"].toString(),
      lastName: userData["last_name"].toString(),
      email: userData["email"].toString(),
      profileUrl: userData["profile_url"].toString(),
      createOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData["created_on"].toString()),
      ),
      joinedExpenses: List<String>.from(userData['joined_expenses'] ?? []),
      pendingExpenses: List<String>.from(userData['pending_expenses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "profile_url": profileUrl,
        "joined_expenses": joinedExpenses,
        "pending_expenses": pendingExpenses,
        "created_on": createOn.millisecondsSinceEpoch.toString(),
      };
}
