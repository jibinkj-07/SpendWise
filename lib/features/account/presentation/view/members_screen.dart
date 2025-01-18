import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/helper/firebase_path.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../widget/member_list_tile.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 16:39:13

class MembersScreen extends StatefulWidget {
  final String budgetId;
  final String budgetName;

  const MembersScreen({
    super.key,
    required this.budgetId,
    required this.budgetName,
  });

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final FirebaseDatabase _firebaseDatabase = sl<FirebaseDatabase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("All Members"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteName.inviteMembers),
            child: Text("Invite"),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _firebaseDatabase
              .ref(FirebasePath.membersPath(widget.budgetId))
              .onValue,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomLoading();
            }

            if (snapshot.hasData &&
                snapshot.data!.snapshot.children.isNotEmpty) {
              final membersData = snapshot.data!.snapshot.children.toList();

              return ListView.builder(
                itemCount: membersData.length,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemBuilder: (ctx, index) {
                  final memberStatus = membersData[index].child("status").value;
                  final memberDate = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(
                        membersData[index].child("date").value.toString()),
                  );

                  return MemberListTile(
                    memberId: membersData[index].key.toString(),
                    budgetId: widget.budgetId,
                    budgetName: widget.budgetName,
                    status: memberStatus.toString(),
                    date: memberDate,
                  );
                },
              );
            }
            return Empty(
              message: "No members joined this budget yet!",
            );
          }),
    );
  }
}
