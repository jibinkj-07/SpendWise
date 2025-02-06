import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features/budget/domain/model/budget_model.dart';
import '../../../features/budget/presentation/bloc/budget_view_bloc.dart';

sealed class AppHelper {
  /// Map for category icons
  static final Map<String, IconData> _icons = {
    "restaurant": Icons.restaurant,
    "fastfood": Icons.fastfood,
    "local_dining": Icons.local_dining,
    "shopping_cart": Icons.shopping_cart,
    "local_grocery_store": Icons.shopping_bag,
    "directions_car": Icons.directions_car,
    "directions_bus": Icons.directions_bus,
    "train": Icons.train,
    "home": Icons.home,
    "apartment": Icons.apartment,
    "house": Icons.house,
    "electrical_services": Icons.electrical_services,
    "water": Icons.water,
    "lightbulb": Icons.lightbulb,
    "movie": Icons.movie,
    "music_note": Icons.music_note,
    "sports_esports": Icons.sports_esports,
    "local_hospital": Icons.local_hospital,
    "healing": Icons.healing,
    "medical_services": Icons.medical_services,
    "security": Icons.security,
    "verified_user": Icons.verified_user,
    "health_and_safety": Icons.health_and_safety,
    "spa": Icons.spa,
    "brush": Icons.brush,
    "local_pharmacy": Icons.local_pharmacy,
    "school": Icons.school,
    "book": Icons.book,
    "library_books": Icons.library_books,
    "shopping_bag": Icons.shopping_bag,
    "shop": Icons.shop,
    "shopping_basket": Icons.shopping_basket,
    "account_balance": Icons.account_balance,
    "payments": Icons.payments,
    "attach_money": Icons.attach_money,
    "flight": Icons.flight,
    "luggage": Icons.luggage,
    "location_on": Icons.location_on,
    "savings": Icons.savings,
    "account_balance_wallet": Icons.account_balance_wallet,
    "card_giftcard": Icons.card_giftcard,
    "volunteer_activism": Icons.volunteer_activism,
    "favorite": Icons.favorite,
    "receipt_long": Icons.receipt_long,
    "request_quote": Icons.request_quote,
    "trending_up": Icons.trending_up,
    "stacked_line_chart": Icons.stacked_line_chart,
    "bar_chart": Icons.bar_chart,
  };

  static Map<String, IconData> get categoryIconMap => _icons;

  static IconData getIconFromString(String iconName) =>
      _icons[iconName] ?? Icons.account_balance_rounded;

  /// Function to convert hex string to Color
  static Color stringToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Function to convert Color to hex string
  static String colorToString(Color color) {
    String hex = color.value.toRadixString(16).toUpperCase().substring(2);
    return '#$hex';
  }

  /// Function to return padding
  static double horizontalPadding(Size size) => size.width * .05;

  /// Function to format price
  static String formatAmount(BuildContext context, double amount,
      {int? decimalDigits}) {
    final budgetState = context.read<BudgetViewBloc>().state;
    BudgetModel? budget;
    if (budgetState is BudgetSubscribed) {
      budget = budgetState.budget;
    }
    return NumberFormat.currency(
      name: budget?.currency,
      symbol: budget?.currencySymbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  /// Function to generate a random but consistent color for a given letter
  static Color getColorForLetter(String letter) {
    final int hashCode =
        letter.codeUnitAt(0); // Get the character code of the letter
    Random random =
        Random(hashCode); // Seed the random generator with the hashCode

    // Generate RGB values based on the random number
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    return Color.fromARGB(255, red, green, blue); // Return the color
  }
}
