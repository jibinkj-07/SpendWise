import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../../domain/model/transaction_model.dart';
import '../bloc/transaction_bloc.dart';
import '../helper/transaction_helper.dart';
import '../widget/top_bar.dart';
import '../widget/transaction_list_tile.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:05:55

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  void _fetchTransactions() {
    final budgetState =
        context.read<BudgetViewBloc>().state as BudgetSubscribed;
    context
        .read<TransactionBloc>()
        .add(SubscribeTransaction(budgetId: budgetState.budget.id));
  }

  final ValueNotifier<String> _searchQuery = ValueNotifier("");

  @override
  void initState() {
    _fetchTransactions();
    super.initState();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<TransactionBloc, TransactionState>(
        builder: (ctx, transState) {
      if (transState.status == TransactionStatus.loading) {
        return CustomLoading();
      }

      if (transState.error != null) {
        return Padding(
          padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transState.error!.message,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FilledButton(
                  onPressed: _fetchTransactions,
                  child: Text("Try again"),
                )
              ],
            ),
          ),
        );
      }
      return Column(
        children: [
          TopBar(
            selectedCategoryId: transState.selectedCategoryId,
            size: size,
            searchQuery: _searchQuery,
          ),
          Expanded(
            child: transState.transactions.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: _searchQuery,
                    builder: (ctx, query, _) {
                      List<TransactionModel> transactions =
                          transState.transactions;
                      if (query.isNotEmpty) {
                        transactions = transactions
                            .where(
                              (item) => (item.title
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  item.amount
                                      .toString()
                                      .contains(query.toLowerCase())),
                            )
                            .toList();
                      }

                      if (transactions.isEmpty) {
                        return Empty(message: "Transaction not found");
                      }
                      return CustomScrollView(
                        slivers: [
                          for (final dateHeader
                              in TransactionHelper.groupByDate(transactions)
                                  .entries)
                            Section(
                              title: DateFormat("dd EEEE, MMM yy")
                                  .format(dateHeader.key),
                              amount: AppHelper.formatAmount(
                                context,
                                232,
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
                      );
                    })
                : Empty(
                    message: "No transactions for\n"
                        "${DateFormat.yMMMM().format(transState.date)}"),
          )
        ],
      );
    });
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
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: .8,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: AppHelper.horizontalPadding(size),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}
