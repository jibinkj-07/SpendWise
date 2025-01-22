import 'package:firebase_database/firebase_database.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });

  factory NotificationModel.fromFirebase(DataSnapshot data) =>
      NotificationModel(
        id: data.key.toString(),
        title: data.child("title").value.toString(),
        body: data.child("body").value.toString(),
        date: DateTime.fromMillisecondsSinceEpoch(
          int.parse(data.child("time").value.toString()),
        ),
      );
}
