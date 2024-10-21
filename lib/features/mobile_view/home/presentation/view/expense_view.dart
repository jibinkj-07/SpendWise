import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/expense_list.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/home_header.dart';
import 'package:my_budget/features/mobile_view/util/bloc_helper.dart';
import 'package:my_budget/features/mobile_view/util/widget/loading.dart';
import 'package:my_budget/features/mobile_view/util/widget/no_access.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:14:56

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, authState) {
        if (authState.userInfo != null &&
            authState.userInfo!.adminId.isNotEmpty) {
          return BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (ctx, expenseState) {
              if (expenseState.expenseStatus == ExpenseStatus.loading) {
                return const Loading();
              }

              return Column(
                children: [
                  HomeHeader(
                    expenseList: BlocHelper.getSelectedMonthList(expenseState),
                    selectedDate: expenseState.selectedDate,
                  ),
                  Expanded(
                    child: ExpenseList(
                      expenseList:
                          BlocHelper.getSelectedMonthList(expenseState),
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const NoAccess();
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
