import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/util/widget/custom_loading.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'features/home/presentation/view/decision_screen.dart';
import 'features/home/presentation/view/home_screen.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 15:07:08

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        /// Show loading screen [Data is fetching from database]
        if (state.authStatus == AuthStatus.loading) {
          return CustomLoading(appLaunch: true);
        }

        /// Navigate to home screen [User already logged]
        if (state.currentUser != null) {
          if (state.currentUser!.selectedBudget.isEmpty) {
            return DecisionScreen();
          }
          return HomeScreen();
        }

        return LoginScreen();
      },
    );
  }
}
