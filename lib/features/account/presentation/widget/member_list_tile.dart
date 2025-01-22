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

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 16:57:02

class MemberListTile extends StatelessWidget {
  final User member;
  final String budgetId;
  final String budgetName;
  final bool isRequest;

  const MemberListTile({
    super.key,
    required this.member,
    required this.budgetId,
    required this.budgetName,
    this.isRequest = false,
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
      child: BlocConsumer<AccountBloc, AccountState>(
        builder: (BuildContext context, AccountState state) {
          final loading = (state is Deleting) || (state is Accepting);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
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
                          Text(
                            member.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            member.email,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                member.userStatus.firstLetterToUpperCase(),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd().add_jm().format(member.date),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (!loading) ...[
                Divider(
                  height: 0,
                  thickness: .5,
                  color: Colors.grey.shade300,
                ),
                Row(
                  mainAxisAlignment: isRequest
                      ? MainAxisAlignment.spaceAround
                      : MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (ctx) => MemberDeleteDialog(
                            fromRequest: isRequest,
                            budgetId: budgetId,
                            budgetName: budgetName,
                            memberId: member.uid,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppConfig.errorColor,
                      ),
                      child: Text("Remove"),
                    ),
                    if (isRequest)
                      TextButton(
                        onPressed: () {
                          context.read<AccountBloc>().add(
                                AcceptAccess(
                                  memberId: member.uid,
                                  budgetId: budgetId,
                                  budgetName: budgetName,
                                ),
                              );
                        },
                        child: Text("Accept"),
                      ),
                  ],
                )
              ] else
                Container(
                  height: 50.0,
                  width: 50.0,
                  padding: const EdgeInsets.all(15.0),
                  child: const CustomLoading(),
                )
            ],
          );
        },
        listener: (BuildContext context, AccountState state) {},
      ),
    );
  }
}
