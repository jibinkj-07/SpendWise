import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../analysis/presentation/widgets/bottom_date_picker.dart';
import '../../../transactions/presentation/widget/trans_bottom_date_picker.dart';

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
    final size = MediaQuery.sizeOf(context);
    return Container(
      margin: EdgeInsets.only(
        left: size.width * .02,
        right: size.width * .02,
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
                  horizontal: size.width * .05,
                  vertical: 8.0,
                ),
                tabBackgroundColor: AppConfig.primaryColor,
                haptic: true,
                tabBorderRadius: 100,
                gap: 8,
                activeColor: Colors.white,
                color: Colors.black54,
                tabs: [
                  GButton(
                    icon: Iconsax.house_2,
                    text: 'Home',    textStyle: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  GButton(
                    icon: Iconsax.chart_3,
                    text: 'Analytics',    textStyle: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                  GButton(
                    icon: Iconsax.document_text,
                    text: 'Transactions',
                    textStyle: TextStyle(
                      fontSize: 12.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: size.width * .02),
          if (currentIndex == 0)
            IconButton.filled(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  RouteName.transactionEntry,
                );
              },
              icon: Icon(Iconsax.add),
            )
          else
            IconButton.filled(
              onPressed: () => currentIndex == 1
                  ? BottomDatePicker.showDialog(context)
                  : TransBottomDatePicker.showDialog(context),
              icon: Icon(Iconsax.calendar_edit),
            )
        ],
      ),
    );
  }
}
