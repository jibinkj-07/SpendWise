import 'package:flutter/material.dart';
import 'package:my_budget/features/mobile_view/util/mobile_view_helper.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:19:54

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;

  const MyAppBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(MobileViewHelper.getAppBarTitle(index)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
