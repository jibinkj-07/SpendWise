import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/widget/access_error.dart';
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
        if (transState.error != null) {
          return AccessError(size: size);
        }

        if (transState.status == TransactionStatus.loading) {
          return CustomLoading();
        }

        return Column(
          children: [
            TopBar(
              selectedCategoryId: transState.selectedCategoryId,
              size: size,
              searchQuery: _searchQuery,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey(transState.selectedCategoryId),
                  child: transState.transactions.isNotEmpty
                      ? ValueListenableBuilder(
                          valueListenable: _searchQuery,
                          builder: (ctx, query, _) {
                            List<TransactionModel> transactions =
                                transState.transactions;

                            if (query.isNotEmpty) {
                              transactions = transactions
                                  .where(
                                    (item) =>
                                        item.title
                                            .toLowerCase()
                                            .contains(query.toLowerCase()) ||
                                        item.amount
                                            .toString()
                                            .contains(query.toLowerCase()),
                                  )
                                  .toList();
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                              child: transactions.isNotEmpty
                                  ? CustomScrollView(
                                      slivers: [
                                        for (final dateHeader
                                            in TransactionHelper.groupByDate(
                                                    transactions)
                                                .entries)
                                          Section(
                                            title: DateFormat("dd EEEE, MMM yy")
                                                .format(dateHeader.key),
                                            size: size,
                                            items: List.generate(
                                              dateHeader.value.length,
                                              (index) => TransactionListTile(
                                                  transaction:
                                                      dateHeader.value[index]),
                                            ),
                                          ),
                                        const SliverToBoxAdapter(
                                            child: SizedBox(height: 80)),
                                      ],
                                    )
                                  : Empty(message: "Transaction not found"),
                            );
                          },
                        )
                      : Empty(
                          message:
                              "No transactions for\n${DateFormat.yMMMM().format(transState.date)}"),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class Section extends MultiSliver {
  Section({
    super.key,
    required Size size,
    required String title,
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
