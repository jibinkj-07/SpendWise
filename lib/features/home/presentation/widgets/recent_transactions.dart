import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../../../transactions/presentation/widget/transaction_list_tile.dart';

/// @author : Jibin K John
/// @date   : 16/12/2024
/// @time   : 19:00:49

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Size size;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppHelper.horizontalPadding(size),
          ),
          child: Text(
            "Recent Transactions",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: transactions.isNotEmpty
              ? Material(
                  color: Colors.transparent,
                  child: CustomScrollView(
                    slivers: [
                      for (final dateHeader
                          in TransactionHelper.groupByDate(transactions)
                              .entries)
                        Section(
                          title: DateFormat("dd EEEE").format(dateHeader.key),
                          amount: AppHelper.formatAmount(
                            context,
                            TransactionHelper.findDayWiseTotal(
                              transactions,
                              dateHeader.key,
                            ),
                          ),
                          size: size,
                          context: context,
                          items: List.generate(
                            dateHeader.value.length,
                            (index) => TransactionListTile(
                              transaction: dateHeader.value[index],
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * .1,
                        ),
                      ),
                    ],
                  ),
                )
              : Empty(message: "No History"),
        )
      ],
    );
  }
}

class Section extends MultiSliver {
  Section({
    super.key,
    required Size size,
    required BuildContext context,
    required String title,
    required String amount,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade200, width: .8)),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: AppHelper.horizontalPadding(size),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15.5,
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 15.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}
