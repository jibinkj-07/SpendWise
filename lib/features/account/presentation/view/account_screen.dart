import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 15:31:03


class AccountScreen extends StatelessWidget {
const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("AccountScreen"),
        centerTitle: true,
      ),
      body: Center(child: Text("AccountScreen")),
    );
  }
}

