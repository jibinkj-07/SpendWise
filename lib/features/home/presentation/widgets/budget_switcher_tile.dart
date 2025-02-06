import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../account/presentation/helper/account_helper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../helper/home_helper.dart';
import 'package:shimmer/shimmer.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 18:29:10

class BudgetSwitcherTile extends StatefulWidget {
  final String id;
  final int currentIndex;
  final BudgetModel budgetDetail;
  final bool fromRequestedScreen;

  const BudgetSwitcherTile({
    super.key,
    required this.id,
    required this.currentIndex,
    required this.budgetDetail,
    required this.fromRequestedScreen,
  });

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
    return ValueListenableBuilder(
      valueListenable: _budget,
      builder: (ctx, budget, child) {
        return budget != null
            ? ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  final authBloc =
                      (context.read<AuthBloc>().state as Authenticated);
                  await _accountHelper.updateSelectedBudget(
                    id: authBloc.user.uid,
                    budgetId: budget.id,
                  );

                  if (widget.fromRequestedScreen) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(RouteName.root, (_) => false);
                  } else if (widget.budgetDetail.id != budget.id) {
                    loadBudget(context, widget.currentIndex, budget.id);
                  }
                },
                leading: CircleAvatar(
                  child: Text(budget.currencySymbol),
                ),
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(budget.name),
                trailing: widget.budgetDetail.id == budget.id
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      )
                    : null,
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
    );
  }

  Future<void> _initBudget() async {
    _budget.value = await _homeHelper.getBudgetDetail(widget.id);
  }
}
