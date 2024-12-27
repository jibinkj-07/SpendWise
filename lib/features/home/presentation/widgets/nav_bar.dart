
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';

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
    return Container(
      margin: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
        bottom: 20.0,
        top: 5.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: .5,
                  color: Colors.grey.withOpacity(.3),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(200.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: GNav(
                selectedIndex: currentIndex,
                onTabChange: (value) => index.value = value,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                tabBackgroundColor: AppConfig.primaryColor,
                haptic: true,
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
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          IconButton.filled(
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteName.transactionEntry,
              );
            },
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
