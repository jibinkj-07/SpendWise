import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../core/util/helper/app_helper.dart';

class CategoryModel {
  final String id;
  final String name;
  final Color color;
  final String icon;
  final DateTime createdOn;
  final String createdBy;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdOn,
    required this.createdBy,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    String? icon,
    Color? color,
    String? createdBy,
    DateTime? createdOn,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        createdBy: createdBy ?? this.createdBy,
        createdOn: createdOn ?? this.createdOn,
      );

  factory CategoryModel.deleted() => CategoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdOn: DateTime.now(),
        color: Colors.black,
        name: 'Deleted Category',
        icon: AppHelper.categoryIconMap.entries.first.key,
        createdBy: '',
      );

  factory CategoryModel.fromFirebase(DataSnapshot categoryData) {
    return CategoryModel(
      id: categoryData.key.toString(),
      name: categoryData.child("name").value.toString(),
      color:
          AppHelper.stringToColor(categoryData.child("color").value.toString()),
      createdOn: DateTime.fromMillisecondsSinceEpoch(
        int.parse(categoryData.child("created_on").value.toString()),
      ),
      createdBy: categoryData.child("created_by").value.toString(),
      icon: categoryData.child("icon").value.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
        "color": color,
        "created_by": createdBy,
        "created_on": createdOn.millisecondsSinceEpoch.toString(),
      };
}
