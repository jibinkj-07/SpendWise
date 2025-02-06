import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/core/util/extension/string_ext.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../domain/model/user.dart';
import '../bloc/account_bloc.dart';
import 'display_image.dart';
import 'member_delete_dialog.dart';

class MemberListTile extends StatelessWidget {
  final User member;
  final String budgetId;
  final String adminId;
  final String budgetName;
  final bool isJoinRequest;

  const MemberListTile({
    super.key,
    required this.member,
    required this.budgetId,
    required this.adminId,
    required this.budgetName,
    this.isJoinRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppHelper.horizontalPadding(size),
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8.0,
          ),
        ],
      ),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState state) {
          final loading = (state is Deleting) || (state is Accepting);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMemberInfo(context),
              if (member.uid != adminId) ...[
                if (!loading) _buildActionButtons(context) else _buildLoading(),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildMemberInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          DisplayImage(
            imageUrl: member.imageUrl,
            height: 85.0,
            width: 85.0,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (member.uid == adminId) ...[
                      const Icon(Icons.admin_panel_settings_rounded),
                      const SizedBox(width: 5.0),
                    ],
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Text(
                  member.email,
                  style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      member.userStatus.firstLetterToUpperCase(),
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(member.date),
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const Divider(
          height: 0,
          thickness: .5,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: isJoinRequest
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _onRemovePressed(context),
              style: TextButton.styleFrom(
                foregroundColor: AppConfig.errorColor,
              ),
              child: const Text("Remove"),
            ),
            if (isJoinRequest)
              TextButton(
                onPressed: () => _onAcceptPressed(context),
                child: const Text("Accept"),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 50.0,
      width: 50.0,
      child: CustomLoading(),
    );
  }

  void _onRemovePressed(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => MemberDeleteDialog(
        isJoinRequest: isJoinRequest,
        budgetId: budgetId,
        budgetName: budgetName,
        memberId: member.uid,
      ),
    );
  }

  void _onAcceptPressed(BuildContext context) {
    context.read<AccountBloc>().add(
          AcceptAccess(
            memberId: member.uid,
            budgetId: budgetId,
            budgetName: budgetName,
          ),
        );
  }
}
