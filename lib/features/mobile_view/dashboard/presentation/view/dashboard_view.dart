import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../util/widget/no_access.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:15:21

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (ctx, authState) {
      return NoAccess();
    });
  }
}
