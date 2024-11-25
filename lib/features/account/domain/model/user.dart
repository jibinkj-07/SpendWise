enum UserStatus { accepted, pending }

class User {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final UserStatus userStatus;
  final DateTime date;

  User({
    required this.uid,
    required this.name,
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
        name: name,
        email: email,
        imageUrl: imageUrl,
        userStatus: userStatus ?? this.userStatus,
        date: date ?? this.date,
      );
}
