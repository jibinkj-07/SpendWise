import 'package:firebase_database/firebase_database.dart';

class CategoryModel {
  final String id;
  final DateTime createdOn;
  final String title;
  final String color;

  CategoryModel({
    required this.id,
    required this.title,
    required this.createdOn,
    required this.color,
  });

  CategoryModel copyWith({
    String? id,
    DateTime? createdOn,
    String? title,
    String? color,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        title: title ?? this.title,
        color: color ?? this.color,
        createdOn: createdOn ?? this.createdOn,
      );

  factory CategoryModel.fromFirebase(DataSnapshot categoryData) {
    return CategoryModel(
        id: categoryData.key.toString(),
        title: categoryData.child("title").value.toString(),
        createdOn:
            DateTime.parse(categoryData.child("created_on").value.toString()),
        color: categoryData.child("color").value.toString());
  }

  Map<String, dynamic> toFirebaseJson() => {
        id: {
          "title": title,
          "color": color,
          "created_on": createdOn.toString(),
        },
      };
}
