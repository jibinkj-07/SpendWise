import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/widget/custom_loading.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../analysis/presentation/view/analysis_view.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/presentation/bloc/budget_bloc.dart';
import '../../../budget/presentation/bloc/category_bloc.dart';
import '../../../transactions/presentation/view/transaction_view.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/nav_bar.dart';
import 'home_view.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 14:29:51

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _index = ValueNotifier(0);
  final _views = [HomeView(), AnalysisView(), TransactionView()];

  @override
  void initState() {
    super.initState();
    final currentBudget =
        context.read<AuthBloc>().state.currentUser?.selectedBudget ?? "";
    context.read<BudgetBloc>().add(FetchBudget(budgetId: currentBudget));
    context.read<CategoryBloc>().add(FetchCategory(budgetId: currentBudget));
  }

  @override
  void dispose() {
    super.dispose();
    _index.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // return CustomLoading(appLaunch: true);
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (ctc, state) {
        if (state.error != null) {
          return Scaffold(
            body: Center(child: Text(state.error?.message ?? "Error Occurred")),
          );
        }

        if (state.status == BudgetStatus.loading) {
          return CustomLoading(appLaunch: true);
        }
        log(context
            .read<AuthBloc>()
            .state
            .currentUser!
            .selectedBudget
            .toString());
        return ValueListenableBuilder(
          valueListenable: _index,
          builder: (ctx, index, _) {
            return PopScope(
              canPop: index == 0,
              onPopInvokedWithResult: (_, __) => _index.value = 0,
              child: Scaffold(
                appBar: MyAppBar(
                  index: index,
                  budgetName: state.budgetDetail?.name ?? "Budget",
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppHelper.horizontalPadding(size),
                  ),
                  child: _views[index],
                ),
                bottomNavigationBar: NavBar(index: _index, currentIndex: index),
              ),
            );
          },
        );
      },
    );
  }
}
