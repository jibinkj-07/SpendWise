import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spend_wise/core/util/extension/string_ext.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../domain/model/user.dart';
import '../helper/account_helper.dart';
import 'display_image.dart';
import 'member_delete_dialog.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 16:57:02

class MemberListTile extends StatefulWidget {
  final String memberId;
  final String budgetId;
  final String budgetName;
  final String status;
  final DateTime date;

  const MemberListTile({
    super.key,
    required this.memberId,
    required this.budgetId,
    required this.budgetName,
    required this.status,
    required this.date,
  });

  @override
  State<MemberListTile> createState() => _MemberListTileState();
}

class _MemberListTileState extends State<MemberListTile> {
  final AccountHelper _accountHelper = sl<AccountHelper>();
  final ValueNotifier<User?> _user = ValueNotifier(null);

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        valueListenable: _user,
        builder: (ctx, user, child) {
          if (user == null) return child!;
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            tileColor: Colors.grey.shade200,
            leading: DisplayImage(
              imageUrl: user.imageUrl,
              height: 50.0,
              width: 50.0,
            ),
            title: Text(user.name),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email),
                Text(DateFormat.yMMMd().add_jm().format(widget.date)),
                Text(widget.status.firstLetterToUpperCase()),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx) => MemberDeleteDialog(
                    budgetId: widget.budgetId,
                    budgetName: widget.budgetName,
                    memberId: widget.memberId,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Remove"),
            ),
          );
        },
        child: ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(.5),
            ),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Container(
              width: 20.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          subtitle: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Container(
                width: 100.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getUserInfo() async {
    await _accountHelper.getUserInfoByID(id: widget.memberId).then((result) {
      if (result.isRight) {
        _user.value = result.right;
      }
    });
  }
}
