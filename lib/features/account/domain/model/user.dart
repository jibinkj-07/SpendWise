import '../../../../core/util/constant/constants.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String userStatus;
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
    String? userStatus,
  }) =>
      User(
        uid: uid,
        name: name,
        email: email,
        imageUrl: imageUrl,
        userStatus: userStatus ?? this.userStatus,
        date: date ?? this.date,
      );

  factory User.deleted(String uid) => User(
        uid: uid,
        name: kDeletedUser,
        email: "Not applicable",
        imageUrl: kDefaultProfile,
        userStatus: "",
        date: DateTime.now(),
      );
}
