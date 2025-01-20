import 'package:flutter/material.dart';

import '../widget/inbox.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 17:52:58

class MyInvitationScreen extends StatelessWidget {
  final String userId;

  const MyInvitationScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Invitations"),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              dividerHeight: 0,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Inbox"),
                Tab(text: "My Requests"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Inbox(userId: userId),
                  Text("2"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
