import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/helper/firebase_path.dart';

/// @author : Jibin K John
/// @date   : 14/11/2024
/// @time   : 14:29:51

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _sub();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () {},
            child: Text("Put"),
          ),
          FilledButton(
            onPressed: () async {
              // final user=context.read<AuthBloc>().state.currentUser;
            },
            child: Text("Get"),
          ),
        ],
      ),
    );
  }

  void _sub() {
    FirebaseDatabase.instance
        .ref(FirebasePath.expensePath("expenseId"))
        .onValue
        .listen(
      (DatabaseEvent event) {
        if (event.snapshot.exists) {
          log("data is ${event.snapshot.value.runtimeType}");
        }
      },
    );
  }
}
