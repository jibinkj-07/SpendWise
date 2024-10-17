import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/injection/imports.dart';
import 'package:my_budget/core/config/route/route_mapper.dart';
import 'package:my_budget/core/constants/app_constants.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 20:17:07

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        _loading.value = state.authStatus == AuthStatus.signingOut;
        if (state.error != null) {
          state.error!.showSnackBar(context);
        }

        if (state.userInfo == null) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteMapper.login,
            (route) => false,
          );
        }
      },
      child: ListView(
        children: [
          const CircleAvatar(
            radius: 40.0,
            child: Icon(
              Icons.account_circle_outlined,
              size: 40.0,
            ),
          ),
          const SizedBox(height: 20.0),
          ValueListenableBuilder(
              valueListenable: _loading,
              builder: (ctx, loading, _) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: loading
                      ? const Center(
                          child: SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: CircularProgressIndicator(strokeWidth: 2.0),
                          ),
                        )
                      : FilledButton(
                        onPressed: () =>
                            context.read<AuthBloc>().add(SignOut()),
                        child: const Text("Sign out"),
                      ),
                );
              }),
          Center(child: Text("Version ${AppConstants.kAppVersion}")),
        ],
      ),
    );
  }
}
