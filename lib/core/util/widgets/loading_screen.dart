import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 19:19:27

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    );
  }
}
