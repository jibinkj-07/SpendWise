import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../account/presentation/widget/display_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import 'budget_switcher.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:33:41

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  final BudgetModel budgetDetail;

  const MyAppBar({
    super.key,
    required this.index,
    required this.budgetDetail,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      if (state is Authenticated) {
        return AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(RouteName.account),
              child: DisplayImage(
                imageUrl: state.user.profileUrl,
                width: 45.0,
                height: 45.0,
              ),
            ),
            title: Text(
              state.user.name,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            subtitle: Text(
              budgetDetail.name,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _showBudgetSwitcher(context),
              style: IconButton.styleFrom(foregroundColor: Colors.black),
              icon: Icon(Icons.swap_vertical_circle_outlined),
            ),
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              icon: state.user.notificationStatus
                  ? Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.red,
                    )
                  : Icon(Icons.notifications_none_rounded),
            ),
          ],
        );
      }
      return AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text("Authentication Error"),
      );
    });
  }

  Future _showBudgetSwitcher(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => BudgetSwitcher(
        currentIndex: index,
        budgetDetail: budgetDetail,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
