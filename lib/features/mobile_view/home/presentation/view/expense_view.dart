import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/config/injection/imports.dart';
import 'package:my_budget/core/util/helper/app_helper.dart';
import 'package:my_budget/features/common/presentation/bloc/expense_bloc.dart';
import 'package:my_budget/features/mobile_view/util/widget/no_access.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:14:56

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, authState) {
        if (authState.userInfo != null &&
            authState.userInfo!.adminId.isNotEmpty) {
          return Text("hey");
        }
        return const NoAccess();
      },
    );
  }
}
