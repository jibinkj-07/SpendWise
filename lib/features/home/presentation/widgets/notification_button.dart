import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/helper/firebase_path.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 20:02:46

class NotificationButton extends StatefulWidget {
  final String userId;

  const NotificationButton({super.key, required this.userId});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  final FirebaseDatabase _firebaseDatabase = sl<FirebaseDatabase>();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteName.notification),
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      icon: StreamBuilder(
        stream: _firebaseDatabase
            .ref(FirebasePath.userSettings(widget.userId))
            .child(FirebasePath.newNotification)
            .onValue,
        builder: (ctx, snapshot) {
          bool unRead = false;
          if (snapshot.hasData) {
            unRead = snapshot.data!.snapshot.value.toString() == "true";
          }

          return unRead
              ? Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.red,
                )
              : Icon(Icons.notifications_none_rounded);
        },
      ),
    );
  }
}
