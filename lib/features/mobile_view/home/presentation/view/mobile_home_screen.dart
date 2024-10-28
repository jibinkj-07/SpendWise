import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view/account_view.dart';
import 'package:my_budget/features/mobile_view/dashboard/presentation/view/dashboard_view.dart';
import 'package:my_budget/features/mobile_view/goal/presentation/view/goal_view.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/expense_view.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/my_app_bar.dart';
import 'package:my_budget/features/mobile_view/home/presentation/widget/nav_bar.dart';

import '../../../../common/presentation/bloc/category_bloc.dart';
import '../../../../common/presentation/bloc/expense_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../goal/presentation/bloc/goal_bloc.dart';
import '../widget/floating_button.dart';

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
  void initState() {
    _initAppStates();
    super.initState();
  }

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
          body: _views[index],
          bottomNavigationBar: NavBar(selectedIndex: index, index: _index),
          floatingActionButton: FloatingButton(index: index),
        );
      },
    );
  }

  void _initAppStates() {
    // Fetching expense data from firebase when user land this page
    final userBloc = context.read<AuthBloc>().state;
    if (userBloc.userInfo != null && userBloc.userInfo!.adminId.isNotEmpty) {
      // Getting all expense details
      context
          .read<ExpenseBloc>()
          .add(GetAllExpense(adminId: userBloc.userInfo!.adminId));

      // Getting all category details
      context
          .read<CategoryBloc>()
          .add(GetAllCategory(adminId: userBloc.userInfo!.adminId));

      // Getting all goal details
      context
          .read<GoalBloc>()
          .add(GetGoal(adminId: userBloc.userInfo!.adminId));
    }
  }
}
