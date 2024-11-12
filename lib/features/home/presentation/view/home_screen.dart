import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 12/11/2024
/// @time   : 21:11:30


class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("HomeScreen"),
        centerTitle: true,
      ),
      body: Center(child: Text("HomeScreen")),
    );
  }
}

