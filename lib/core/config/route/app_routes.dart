import 'package:flutter/material.dart';
import 'package:my_budget/features/mobile_view/account/presentation/view/category_add_screen.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/view/login_screen.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/view/reset_password_screen.dart';
import 'package:my_budget/features/mobile_view/auth/presentation/view/sign_up_screen.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/expense_add_screen.dart';
import 'package:my_budget/features/mobile_view/home/presentation/view/mobile_home_screen.dart';
import '../../../features/root.dart';
import 'error_route.dart';
import 'route_mapper.dart';

sealed class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;

    /// for get parameters that are passed via navigator
    // OnboardScreen(isDataFetched: args == null ? false : args as bool),
    switch (settings.name) {
      case RouteMapper.root:
        return MaterialPageRoute(builder: (_) => const Root());
      case RouteMapper.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteMapper.create:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RouteMapper.reset:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case RouteMapper.addExpense:
        return MaterialPageRoute(builder: (_) => const ExpenseAddScreen());
      case RouteMapper.mobileHomeScreen:
        return MaterialPageRoute(builder: (_) => const MobileHomeScreen());
      case RouteMapper.addCategory:
        return MaterialPageRoute(builder: (_) => const CategoryAddScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorRoute());
    }
  }
}
