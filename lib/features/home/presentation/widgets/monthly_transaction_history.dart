import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../budget/domain/model/transaction_model.dart';
import '../../../transactions/presentation/helper/transaction_helper.dart';
import '../../../transactions/presentation/widget/transaction_list_tile.dart';

/// @author : Jibin K John
/// @date   : 16/12/2024
/// @time   : 19:00:49

class MonthlyTransactionHistory extends StatefulWidget {
  final List<TransactionModel> transactions;

  const MonthlyTransactionHistory({
    super.key,
    required this.transactions,
  });

  @override
  State<MonthlyTransactionHistory> createState() =>
      _MonthlyTransactionHistoryState();
}

class _MonthlyTransactionHistoryState extends State<MonthlyTransactionHistory> {
  final ValueNotifier<bool> _isAscending = ValueNotifier(false);

  @override
  void dispose() {
    _isAscending.dispose();
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
              "Transaction History",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              label: Text("Sort"),
              icon: Icon(Icons.sort_rounded),
            )
          ],
        ),
        Expanded(
          child: widget.transactions.isNotEmpty
              ? ValueListenableBuilder(
                  valueListenable: _isAscending,
                  builder: (ctx, isAscend, _) {
                    final groupedData = TransactionHelper.groupByDate(
                      widget.transactions,
                      isAscend,
                    );
                    return     Material(
                      color: Colors.transparent,
                      child: CustomScrollView(
                        slivers: [
                          for (final dateHeader in groupedData.entries)
                            Section(
                              title: DateFormat("dd EEEE").format(dateHeader.key),
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
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 100.0),
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
