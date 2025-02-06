import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spend_wise/core/util/widget/custom_alert.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 12:56:35

class Sample extends StatelessWidget {
  const Sample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sample"),
        centerTitle: true,
      ),
      body: FilledButton(
        onPressed: () {
          // CustomAlert.show(
          //     context: context,
          //     message: "Are you sure you want to delete this member",
          //     onAction: () {
          //       log("called");
          //     },
          //     title: "Delete Member");
        },
        child: Text("Custom Alert"),
      ),
    );
  }
}
