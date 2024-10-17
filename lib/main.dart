import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'core/config/bloc/bloc_providers.dart';
import 'core/config/injection/injection_container.dart';
import 'core/config/route/app_routes.dart';
import 'core/config/route/route_mapper.dart';
import 'core/config/theme/app_theme.dart';
import 'features/mobile_view/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing backend database [firebase]
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialising injection container
  await initDependencies();

  sl<AuthBloc>().add(InitUser());

  // restricting application orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: BlocProviders.list,
        child: const MyApp(),
      ),
    ),
  );
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
