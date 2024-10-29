import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/route/route_mapper.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../goal/presentation/bloc/goal_bloc.dart';

/// @author : Jibin K John
/// @date   : 28/10/2024
/// @time   : 13:27:14

class FloatingButton extends StatelessWidget {
  final int index;

  const FloatingButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return (index == 0 || index == 2)
        ? BlocBuilder<AuthBloc, AuthState>(
            builder: (ctx, authState) {
              if (authState.userInfo != null &&
                  authState.userInfo!.adminId.isNotEmpty) {
                return index == 0
                    ? FloatingActionButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteMapper.addExpense,
                        ),
                        child: const Icon(Icons.add_rounded),
                      )
                    : FloatingActionButton.extended(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          RouteMapper.createGoal,
                        ),
                        label: const Text("Set Goal"),
                      );
              }
              return const SizedBox.shrink();
            },
          )
        : const SizedBox.shrink();
  }
}
