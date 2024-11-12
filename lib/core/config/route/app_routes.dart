import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/view/create_account_screen.dart';
import 'package:spend_wise/features/auth/presentation/view/password_reset_screen.dart';
import 'package:spend_wise/features/home/presentation/view/home_screen.dart';
import '../../../features/auth/presentation/view/login_screen.dart';
import '../../../root.dart';
import 'error_route.dart';

/// class for adding page route name entry
sealed class RouteName {
  static const String root = "root";
  static const String login = "login-screen";
  static const String createAccount = "create-account-screen";
  static const String passwordReset = "password-reset-screen";
  static const String home = "home";
}

/// class for declaring app page navigation screens

sealed class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;

    /// for get parameters that are passed via navigator
    // OnboardScreen(isDataFetched: args == null ? false : args as bool),
    switch (settings.name) {
      case RouteName.root:
        return MaterialPageRoute(builder: (_) => const Root());
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
      case RouteName.passwordReset:
        return MaterialPageRoute(builder: (_) => const PasswordResetScreen());
      case RouteName.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorRoute());
    }
  }
}
