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

class RecentTransactions extends StatefulWidget {
  final List<TransactionModel> transactions;

  const RecentTransactions({
    super.key,
    required this.transactions,
  });

  @override
  State<RecentTransactions> createState() => _RecentTransactions();
}

class _RecentTransactions extends State<RecentTransactions> {
  final ValueNotifier<TransactionFilter> _filter =
      ValueNotifier(TransactionFilter.recent);

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            PopupMenuButton(
              surfaceTintColor: Colors.transparent,
              color: Colors.blue.shade50,
              iconColor: AppConfig.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  child: Text("Recent"),
                  onTap: () => _filter.value = TransactionFilter.recent,
                ),
                PopupMenuItem(
                  child: Text("Oldest"),
                  onTap: () => _filter.value = TransactionFilter.oldest,
                ),
                PopupMenuItem(
                  child: Text("High to Low"),
                  onTap: () => _filter.value = TransactionFilter.highToLow,
                ),
                PopupMenuItem(
                  child: Text("Low to High"),
                  onTap: () => _filter.value = TransactionFilter.lowToHigh,
                ),
              ],
              icon: Icon(Icons.sort_rounded),
            )
          ],
        ),
        Expanded(
          child: widget.transactions.isNotEmpty
              ? ValueListenableBuilder(
                  valueListenable: _filter,
                  builder: (ctx, filter, _) {
                    final groupedData = TransactionHelper.groupByDate(
                      widget.transactions,
                      filter,
                    );
                    return Material(
                      color: Colors.transparent,
                      child: CustomScrollView(
                        slivers: [
                          for (final dateHeader in groupedData.entries)
                            Section(
                              title:
                                  DateFormat("dd EEEE").format(dateHeader.key),
                              amount: AppHelper.formatAmount(
                                context,
                                TransactionHelper.findDayWiseTotal(
                                  widget.transactions,
                                  dateHeader.key,
                                ),
                              ),
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
                    );
                  })
              : Empty(message: "No History"),
        )
      ],
    );
  }
}

class Section extends MultiSliver {
  Section({
    super.key,
    required BuildContext context,
    required String title,
    required String amount,
    required List<Widget> items,
  }) : super(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black54),
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
