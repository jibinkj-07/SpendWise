import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_config.dart';
import 'core/config/injection/injection_container.dart';
import 'core/config/providers/bloc_providers.dart';
import 'core/config/route/app_routes.dart';
import 'core/config/theme/light.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialising injection container
  await initDependencies();

  // restricting application orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: BlocProviders.list,
        child: const SpendWiseApp(),
      ),
    ),
  );
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.name,
      theme: Light.config,
      initialRoute: RouteName.root,
      onGenerateRoute: AppRoutes.generate,
      debugShowCheckedModeBanner: false,
    );
  }
}
