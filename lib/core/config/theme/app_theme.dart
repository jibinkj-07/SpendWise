import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../route/custom_page_transition.dart';

sealed class AppTheme {
  static final data = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.kAppColor),
    useMaterial3: true,
    fontFamily: AppConstants.kFontFamily,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(.15),
        foregroundColor: Colors.blue,
        textStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: AppConstants.kFontFamily,
        ),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CustomPageTransitionBuilder(),
        TargetPlatform.iOS: CustomPageTransitionBuilder(),
      },
    ),
  );
}
