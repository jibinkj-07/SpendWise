import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/injection/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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
      body: Text("Hey"),
    );
  }

  Future<void> _initExpenseListener() async {
    final user = context.read<AuthBloc>().state.currentUser!;
    final expenseId = await _homeHelper.getCurrentExpenseId(user.uid);
  }
}
