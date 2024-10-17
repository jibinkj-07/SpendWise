import 'package:flutter/material.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/mobile_home_screen.dart';
import 'error_route.dart';
import 'route_mapper.dart';

sealed class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;

    /// for get parameters that are passed via navigator
    // OnboardScreen(isDataFetched: args == null ? false : args as bool),
    switch (settings.name) {
      case RouteMapper.root:
      case RouteMapper.mobileHomeScreen:
        return MaterialPageRoute(builder: (_) => const MobileHomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorRoute());
    }
  }
}
