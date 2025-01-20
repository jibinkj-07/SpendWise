import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../domain/model/budget_info.dart';
import '../helper/account_helper.dart';
import 'display_image.dart';

/// @author : Jibin K John
/// @date   : 18/01/2025
/// @time   : 19:03:13

class InvitationTile extends StatefulWidget {
  final bool isMyRequest;
  final String budgetId;
  final String userId;
  final DateTime date;

  const InvitationTile({
    super.key,
    required this.isMyRequest,
    required this.budgetId,
    required this.userId,
    required this.date,
  });

  @override
  State<InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  final AccountHelper _accountHelper = sl<AccountHelper>();
  final ValueNotifier<BudgetInfo?> _budgetInfo = ValueNotifier(null);

  @override
  void initState() {
    _getBudget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder(
        valueListenable: _budgetInfo,
        builder: (ctx, budget, child) {
          if (budget == null) return child!;
          return ListTile(
            title:     Text(
              budget.budget.name,

            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Admin : ${budget.admin.name}"),
                Text(
                    "Currency : ${budget.budget.currencySymbol} ${budget.budget.currency}"),
                Text(
                    "Invited on : ${DateFormat.yMMMd().add_jm().format(widget.date)}"),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Reject"),
                    ),
                    const SizedBox(width: 10.0),
                    FilledButton(
                      onPressed: () {},
                      child: Text("Accept"),
                    ),
                  ],
                )
              ],
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

  Future<void> _getBudget() async {
    await _accountHelper
        .getBudgetInfo(budgetId: widget.budgetId)
        .then((result) {
      if (result.isRight) {
        _budgetInfo.value = result.right;
      }
    });
  }
}
