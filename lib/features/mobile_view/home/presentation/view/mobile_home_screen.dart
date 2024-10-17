import 'package:flutter/material.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view/account_view.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view/dashboard_view.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/view/goal_view.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/expense_view.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/my_app_bar.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/nav_bar.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 11:59:08

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final ValueNotifier<int> _index = ValueNotifier(0);
  final List<Widget> _views = const [
    ExpenseView(),
    DashboardView(),
    GoalView(),
    AccountView(),
  ];

  @override
  void dispose() {
    _index.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _index,
      builder: (ctx, index, _) {
        return Scaffold(
          appBar: MyAppBar(index: index),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _views[index],
          ),
          bottomNavigationBar: NavBar(selectedIndex: index, index: _index),
        );
      },
    );
  }
}
