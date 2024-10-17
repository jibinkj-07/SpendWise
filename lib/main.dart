import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'core/config/route/app_routes.dart';
import 'core/config/route/route_mapper.dart';
import 'core/config/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Initializing backend database [firebase]
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.kAppName,
      theme: AppTheme.data,
      initialRoute: RouteMapper.root,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
