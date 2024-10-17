import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 17/10/2024
/// @time   : 12:16:02

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueNotifier<int> index;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => index.value = i,
      // surfaceTintColor: AppConstants.kAppColor,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.house_outlined,
            color: selectedIndex == 0 ? Colors.black : Colors.black54,
          ),
          label: 'Home',
          selectedIcon: const Icon(Icons.house_rounded),
        ),
        NavigationDestination(
          icon: Icon(
            Icons.dashboard_outlined,
            color: selectedIndex == 1 ? Colors.black : Colors.black54,
          ),
          label: 'Dashboard',
          selectedIcon: const Icon(Icons.dashboard_rounded),
        ),
        NavigationDestination(
          icon: Icon(
            Icons.flag_outlined,
            color: selectedIndex == 2 ? Colors.black : Colors.black54,
          ),
          label: 'Goal',
          selectedIcon: const Icon(Icons.flag_rounded),
        ),   NavigationDestination(
          icon: Icon(
            Icons.person_outline_rounded,
            color: selectedIndex == 3 ? Colors.black : Colors.black54,
          ),
          label: 'Account',
          selectedIcon: const Icon(Icons.person_rounded),
        ),
      ],
    );
  }
}
