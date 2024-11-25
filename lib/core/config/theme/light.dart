import 'package:flutter/material.dart';

import '../app_config.dart';
import '../route/custom_page_transition.dart';

sealed class Light {
  static ThemeData config = ThemeData(
    colorScheme: ColorScheme(
      inversePrimary: AppConfig.primaryColor,
      onInverseSurface: Colors.white,
      brightness: Brightness.light,
      primary: AppConfig.primaryColor,
      onPrimary: Colors.white,
      secondary: AppConfig.secondaryColor,
      onSecondary: Colors.white,
      surface: Color(0xFFF9F9F9),
      onSurface: Colors.black,
      error: AppConfig.errorColor,
      onError: Colors.white,
      tertiary: Color(0xFFFFA500),
      onTertiary: Color(0xFF333333),
      primaryContainer: Color(0xFFCCE5FF),
      onPrimaryContainer: AppConfig.primaryColor,
      secondaryContainer: Color(0xFFB2DFDB),
      onSecondaryContainer: AppConfig.secondaryColor,
    ),
    fontFamily: AppConfig.fontFamily,
    useMaterial3: true,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppConfig.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.black54,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppConfig.fontFamily,
        color: Colors.black,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12.0,
        fontFamily: AppConfig.fontFamily,
        color: Colors.black87,
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
