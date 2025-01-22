import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import '../widgets/budget_switcher.dart';
import '../widgets/notification_button.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 19:43:13

class RequestedScreen extends StatelessWidget {
  const RequestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Requested"),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
            if (state is Authenticated) {
              return NotificationButton(authState: state);
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  AssetMapper.pendingSVG,
                  height: size.height * .2,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Your request has been sent. The admin needs to approve it before you can join the budget."
                  " Please wait or contact the admin for more information.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              children: [
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(RouteName.createExpense),
                  child: Text("Create New Budget"),
                ),
                TextButton(
                  onPressed: () => _showBudgetSwitcher(context),
                  child: Text("Change Budget"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _showBudgetSwitcher(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => BudgetSwitcher(
        currentIndex: 0,
        budgetDetail: BudgetModel.dummy(),
        fromRequestedScreen: true,
      ),
    );
  }
}
