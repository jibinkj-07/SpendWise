import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import 'invitation_tile.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 18:38:25

class Inbox extends StatefulWidget {
  final String userId;

  const Inbox({super.key, required this.userId});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final FirebaseDatabase _firebaseDatabase = sl<FirebaseDatabase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebaseDatabase
            .ref(FirebasePath.invitationPath(widget.userId))
            .onValue,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoading();
          }

          if (snapshot.hasData && snapshot.data!.snapshot.children.isNotEmpty) {
            final budgets = snapshot.data!.snapshot.children.toList();

            return ListView.builder(
              itemCount: budgets.length,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (ctx, index) {
                // final memberStatus = membersData[index].child("status").value;
                final date = DateTime.fromMillisecondsSinceEpoch(
                  int.parse(budgets[index].child("date").value.toString()),
                );

                return InvitationTile(
                  isMyRequest: false,
                  budgetId: budgets[index].key.toString(),
                  userId: widget.userId,
                  date: date,
                );
              },
            );
          }
          return Empty(
            message: "No budget invitations",
          );
        });
  }
}
