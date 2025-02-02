import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/config/route/app_routes.dart';
import '../bloc/account_bloc.dart';
import '../helper/account_helper.dart';
import '../widget/inbox.dart';
import '../widget/invitation_request.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 17:52:58

class MyInvitationScreen extends StatefulWidget {
  final String userId;

  const MyInvitationScreen({super.key, required this.userId});

  @override
  State<MyInvitationScreen> createState() => _MyInvitationScreenState();
}

class _MyInvitationScreenState extends State<MyInvitationScreen> {
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (BuildContext context, AccountState state) {
        if (state is AccountStateError) {
          state.error.showSnackBar(context);
        }
        if (state is Accepted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.root, (_) => false);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Invitations"),
            centerTitle: true,
            bottom: TabBar(
              dividerHeight: 0,
              unselectedLabelColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: "Inbox"),
                Tab(text: "My Requests"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Inbox(
                accountHelper: _accountHelper,
                userId: widget.userId,
              ),
              InvitationRequest(
                accountHelper: _accountHelper,
                userId: widget.userId,
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
                Navigator.of(context).pushNamed(RouteName.requestJoin),
            icon: Icon(Icons.add_rounded),
            label: Text("Request"),
          ),
        ),
      ),
    );
  }
}
