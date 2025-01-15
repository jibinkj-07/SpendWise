import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/injection/injection_container.dart';
import 'core/config/route/app_routes.dart';
import 'core/util/constant/constants.dart';
import 'core/util/error/failure.dart';
import 'core/util/widget/custom_loading.dart';
import 'features/account/presentation/helper/account_helper.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 15:07:08
class Root extends StatefulWidget {
  final String? userId;

  const Root({
    super.key,
    this.userId,
  });

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final AccountHelper _accountHelper = sl<AccountHelper>();

  @override
  void initState() {
    if (widget.userId != null) {
      _accountHelper.updateSelectedBudget(
        id: widget.userId!,
        budgetId: "",
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        /// SUCCESS
        if (state is Authenticated) {
          if (state.user.selectedBudget.isEmpty) {
            Navigator.pushReplacementNamed(context, RouteName.decision);
          } else if (state.user.selectedBudget == kRequested) {
            // todo;
            log("User's budget is requested.");
          } else {
            Navigator.pushReplacementNamed(context, RouteName.home);
          }
        }

        /// ERRORS
        if (state is AuthError) {
          if (state.error is NetworkError) {
            Navigator.pushReplacementNamed(context, RouteName.networkError);
          } else {
            Navigator.pushReplacementNamed(context, RouteName.login);
          }
        }
      },
      child: CustomLoading(appLaunch: true),
    );
  }
}
