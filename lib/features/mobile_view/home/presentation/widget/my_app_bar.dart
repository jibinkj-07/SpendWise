import 'package:flutter/material.dart';
import 'package:my_budget/features/mobile_view/util/mobile_view_helper.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 13:19:54

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int index;
  final VoidCallback onRefresh;

  const MyAppBar({
    super.key,
    required this.index,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(MobileViewHelper.getAppBarTitle(index)),
      centerTitle: false,
      actions: index == 0
          ? [
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
