import 'package:flutter/material.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../account/presentation/helper/account_helper.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../helper/home_helper.dart';
import 'package:shimmer/shimmer.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 18:29:10

class BudgetSwitcherTile extends StatefulWidget {
  final String id;

  const BudgetSwitcherTile({super.key, required this.id});

  @override
  State<BudgetSwitcherTile> createState() => _BudgetSwitcherTileState();
}

class _BudgetSwitcherTileState extends State<BudgetSwitcherTile> {
  final ValueNotifier<BudgetModel?> _budget = ValueNotifier(null);
  final HomeHelper _homeHelper = sl<HomeHelper>();
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  void initState() {
    super.initState();
    _initBudget();
  }

  @override
  void dispose() {
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ValueListenableBuilder(
        valueListenable: _budget,
        builder: (ctx, budget, child) {
          return budget != null
              ? ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    // _accountHelper.updateSelectedBudget(
                    //   id: context.read<AuthBloc>().state.currentUser?.uid ?? "",
                    //   budgetId: budget.id,
                    // );
                    initBudgetData(context, budget.id);
                  },
                  tileColor: Colors.grey.withOpacity(.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: Text(budget.name),
                  subtitle: Text(budget.currency),
                )
              : child!;
        },
        child: ListTile(
          title: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Container(
              width: 20.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          subtitle: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Container(
                width: 100.0,
                height: 6.0,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initBudget() async {
    _budget.value = await _homeHelper.getBudgetDetail(widget.id);
  }
}
