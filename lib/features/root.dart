import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/util/widgets/loading_screen.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/view/login_screen.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/mobile_home_screen.dart';

import 'mobile_view/auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 15:06:28

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width > 600) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Sorry Desktop version of this app is not available right now."),
              Text("Resize your browser to use Mobile version")
            ],
          ),
        ),
      );
    }
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, state) {
      if (state.authStatus == AuthStatus.gettingUserInfo) {
        return const LoadingScreen();
      }
      if (state.userInfo != null) {
        return const MobileHomeScreen();
      }
      return const LoginScreen();
    });
  }
}
