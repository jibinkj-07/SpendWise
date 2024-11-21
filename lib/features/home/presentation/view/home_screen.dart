import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../expense/presentation/bloc/expense_bloc.dart';
import '../helper/home_helper.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 14:29:51

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeHelper _homeHelper = sl<HomeHelper>();

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
          if (state.currentExpense == null) {
            return Text("No data");
          }
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

  Future<void> _initExpenseListener() async {
    final user = context.read<AuthBloc>().state.currentUser!;
    final expenseId = await _homeHelper.getCurrentExpenseId(user.uid);
    if (expenseId.isNotEmpty) {
      context
          .read<ExpenseBloc>()
          .add(SubscribeExpenseData(expenseId: expenseId));
    }
  }
}
