import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/config/app_config.dart';

/// @author : Jibin K John
/// @date   : 12/12/2024
/// @time   : 14:57:37

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueNotifier<int> index;

  const NavBar({
    super.key,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GNav(
      selectedIndex: currentIndex,
      onTabChange: (value) => index.value = value,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      padding: EdgeInsets.all(10.0),
      tabBackgroundColor: AppConfig.primaryColor,
      haptic: true,
      iconSize: 28.0,
      tabMargin: EdgeInsets.only(bottom: 12.0, top: 5.0),
      tabBorderRadius: 100,
      gap: 5,
      activeColor: Colors.white,
      color: Colors.black54,
      tabs: [
        GButton(
          icon: Icons.home_rounded,
          text: 'Home',
        ),
        GButton(
          icon: Icons.query_stats_rounded,
          text: 'Analysis',
        ),
        GButton(
          icon: Icons.article_rounded,
          text: 'Transaction',
        ),
      ],
    );
  }
}
