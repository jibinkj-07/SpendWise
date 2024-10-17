import 'package:flutter/material.dart';

class ErrorRoute extends StatelessWidget {
  const ErrorRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          splashRadius: 20.0,
        ),
      ),
      body: const Center(
        child: Text('No page found'),
      ),
    );
  }
}