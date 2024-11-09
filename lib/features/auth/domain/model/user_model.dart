class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime createOn;
  final List<String> joinedFamilies;
  final List<String> invitedFamilies;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.createOn,
    required this.joinedFamilies,
    required this.invitedFamilies,
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
      createOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(userData["created_on"].toString()),
      ),
      joinedFamilies: List<String>.from(userData['joined_families'] ?? []),
      invitedFamilies: List<String>.from(userData['invited_families'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "joined_families": joinedFamilies,
        "invited_families": invitedFamilies,
        "created_on": createOn.millisecondsSinceEpoch.toString(),
      };
}
