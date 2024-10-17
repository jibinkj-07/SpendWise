import 'package:my_budget/core/constants/app_constants.dart';

sealed class MobileViewHelper {
  static String getAppBarTitle(int index) {
    switch (index) {
      case 1:
        return "Dashboard";
      case 2:
        return "Goal";
      default:
        return AppConstants.kAppName;
    }
  }
}
