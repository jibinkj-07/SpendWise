import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/route/app_routes.dart';
import 'core/util/constant/constants.dart';
import 'core/util/error/failure.dart';
import 'core/util/widget/custom_loading.dart';
import 'desktop_warning.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 08/11/2024
/// @time   : 15:07:08
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    // Initialing user data
    context.read<AuthBloc>().add(SubscribeUserData());
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width > 600) {
      return const DesktopWarning();
    }
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        /// SUCCESS
        if (state is Authenticated) {
          if (state.settings.currentBudget.isEmpty) {
            Navigator.pushReplacementNamed(context, RouteName.decision);
          } else if (state.settings.currentBudget == kRequested) {
            Navigator.pushReplacementNamed(context, RouteName.requested);
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
