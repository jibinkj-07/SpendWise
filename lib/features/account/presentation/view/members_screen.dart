import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/config/route/app_routes.dart';
import '../helper/account_helper.dart';
import '../widget/invited_members.dart';
import '../widget/requested_members.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 16:39:13

class MembersScreen extends StatefulWidget {
  final String budgetId;
  final String budgetName;
  final String adminId;

  const MembersScreen({
    super.key,
    required this.budgetId,
    required this.budgetName,
    required this.adminId,
  });

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Members"),
          centerTitle: true,
          bottom: TabBar(
            dividerHeight: 0,
            unselectedLabelColor: Colors.black54,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Invited"),
              Tab(text: "Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InvitedMembers(
              budgetName: widget.budgetName,
              budgetId: widget.budgetId,
              accountHelper: _accountHelper,
              adminId: widget.adminId,
            ),
            RequestedMembers(
              budgetName: widget.budgetName,
              budgetId: widget.budgetId,
              accountHelper: _accountHelper,
              adminId: widget.adminId,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppConfig.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteName.inviteMembers),
          icon: Icon(Iconsax.add_circle),
          label: Text("Invite"),
        ),
      ),
    );
  }
}
