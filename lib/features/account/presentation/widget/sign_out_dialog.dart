import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../../core/util/widget/custom_alert.dart';
import '../../../../core/util/widget/loading_filled_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 15:28:36

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (ctx, state) {
        final loading = state is SigningOut;

        return CustomAlertDialog(
          title: loading ? "Signing Out" : "Sign out",
          message: "Are you sure you want to sign out from ${AppConfig.name}",
          actionWidget: LoadingFilledButton(
            loading: loading,
            isDelete: true,
            onPressed: () => context.read<AuthBloc>().add(SignOut()),
            child: Text("Sign Out"),
          ),
          isLoading: loading,
        );
      },
      listener: (BuildContext context, AuthState state) {
        if (state is AuthError) {
          Navigator.pop(context);
          state.error.showSnackBar(context);
        }
        if (state is SignedOut) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.login, (_) => false);
        }
      },
    );
  }
}
