import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/view/create_account_screen.dart';
import 'package:spend_wise/features/auth/presentation/view/password_reset_screen.dart';
import 'package:spend_wise/features/budget/presentation/view/request_budget_join.dart';
import 'package:spend_wise/features/home/presentation/view/category_entry_screen.dart';
import 'package:spend_wise/features/budget/presentation/view/create_budget_screen.dart';
import 'package:spend_wise/features/home/presentation/view/decision_screen.dart';
import 'package:spend_wise/features/home/presentation/view/home_screen.dart';
import '../../../features/account/presentation/view/account_screen.dart';
import '../../../features/account/presentation/view/invite_members_screen.dart';
import '../../../features/auth/presentation/view/login_screen.dart';
import '../../../features/auth/presentation/view/network_error_screen.dart';
import '../../../features/home/presentation/view/requested_screen.dart';
import '../../../features/transactions/presentation/view/transaction_entry_screen.dart';
import '../../../root.dart';
import 'error_route.dart';

/// class for adding page route name entry
sealed class RouteName {
  static const String root = "/";
  static const String login = "/login-screen";
  static const String createAccount = "/create-account-screen";
  static const String passwordReset = "/password-reset-screen";
  static const String home = "/home";
  static const String decision = "/decision-screen";
  static const String createExpense = "/create-expense-screen";
  static const String createCategory = "/create-category-screen";
  static const String inviteMembers = "/invite-members-screen";
  static const String account = "/account-screen";
  static const String transactionEntry = "/transaction-entry-screen";
  static const String networkError = "/network-error-screen";
  static const String requestJoin = "/request-join-screen";
  static const String requested = "/requested-screen";
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
      case RouteName.decision:
        return MaterialPageRoute(builder: (_) => const DecisionScreen());
      case RouteName.createExpense:
        return MaterialPageRoute(builder: (_) => const CreateBudgetScreen());
      case RouteName.createCategory:
        return MaterialPageRoute(builder: (_) => const CategoryEntryScreen());
      case RouteName.inviteMembers:
        return MaterialPageRoute(builder: (_) => const InviteMembersScreen());
      case RouteName.account:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case RouteName.transactionEntry:
        return MaterialPageRoute(
            builder: (_) => const TransactionEntryScreen());
      case RouteName.networkError:
        return MaterialPageRoute(builder: (_) => const NetworkErrorScreen());
      case RouteName.requestJoin:
        return MaterialPageRoute(builder: (_) => const RequestBudgetJoin());
      case RouteName.requested:
        return MaterialPageRoute(builder: (_) => const RequestedScreen());
      default:
        return MaterialPageRoute(builder: (_) => const ErrorRoute());
    }
  }
}
