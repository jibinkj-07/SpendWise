enum UserStatus { accepted, pending }

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final UserStatus userStatus;
  final DateTime date;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.imageUrl,
    required this.userStatus,
    required this.date,
  });

  User copyWith({
    DateTime? date,
    UserStatus? userStatus,
  }) =>
      User(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        imageUrl: imageUrl,
        userStatus: userStatus ?? this.userStatus,
        date: date ?? this.date,
      );
}
