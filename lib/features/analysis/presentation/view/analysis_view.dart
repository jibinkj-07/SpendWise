import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/util/widget/custom_loading.dart';

import '../../../../core/util/helper/app_helper.dart';
import '../../../budget/presentation/bloc/budget_view_bloc.dart';
import '../bloc/analysis_bloc.dart';
import '../widgets/dashboard.dart';
import '../widgets/view_switcher.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:00:42

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  void initState() {
    _fetchTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (ctx, state) {
        return Column(
          children: [
            // Top Bar
            ViewSwitcher(size: size, filter: state.filter),
            Expanded(
              child: Dashboard(
                analysisState: state,
                size: size,
                fetchData: _fetchTransactions,
              ),
            )
          ],
        );
      },
    );
  }

  void _fetchTransactions() {
    final budgetState =
        context.read<BudgetViewBloc>().state as BudgetSubscribed;
    context
        .read<AnalysisBloc>()
        .add(SubscribeAnalysisData(budgetId: budgetState.budget.id));
  }
}
