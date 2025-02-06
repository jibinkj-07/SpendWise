import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
          icon: Icon(Iconsax.arrow_left_2),
          splashRadius: 20.0,
        ),
      ),
      body: const Center(child: Text('No page found')),
    );
  }
}
