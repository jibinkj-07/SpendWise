import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../account/presentation/widget/display_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../budget/domain/model/budget_model.dart';
import 'budget_switcher.dart';
import 'notification_button.dart';

/// @author : Jibin K John
/// @date   : 28/01/2025
/// @time   : 19:07:31

class ErrorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subtitle;

  const ErrorAppBar({super.key, required this.subtitle});

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
              subtitle,
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
            NotificationButton(userState: state),
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
        currentIndex: 0,
        budgetDetail: BudgetModel.dummy(),
        fromRequestedScreen: false,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
