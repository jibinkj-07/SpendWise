import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../expense/presentation/bloc/expense_bloc.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 14:29:51

class HomeScreen extends StatefulWidget {
  final String? expenseId;

  const HomeScreen({super.key, this.expenseId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _initExpenseListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
        centerTitle: true,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Text("Status ${state.expenseStatus}"),
              Text(state.currentExpense!.name),
              Column(
                children: List.generate(state.currentExpense!.categories.length,
                    (index) {
                  return ListTile(
                    title: Text(
                      (state.currentExpense!.categories[index].name),
                    ),
                  );
                }),
              )
            ],
          );
        },
      ),
    );
  }

  void _initExpenseListener() {
    final user = context.read<AuthBloc>().state.currentUser!;
    context.read<ExpenseBloc>().add(
          SubscribeExpenseData(
            expenseId: widget.expenseId ?? user.joinedExpenses.last.expenseId,
          ),
        );
  }
}
