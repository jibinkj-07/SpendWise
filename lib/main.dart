import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // restricting application orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        colorScheme: ColorScheme(
          inversePrimary: Color(0xFF00539F),
          onInverseSurface: Colors.white,
          brightness: Brightness.light,
          primary: Color(0xFF00539F),
          onPrimary: Colors.white,
          secondary: Color(0xFF00796B),
          onSecondary: Colors.white,
          surface: Color(0xFFF9F9F9),
          onSurface: Colors.black,
          error: Color(0xFFEE1C2E),
          onError: Colors.white,
          tertiary: Color(0xFFFFA500),
          onTertiary: Color(0xFF333333),
          primaryContainer: Color(0xFFCCE5FF),
          onPrimaryContainer: Color(0xFF00539F),
          secondaryContainer: Color(0xFFB2DFDB),
          onSecondaryContainer: Color(0xFF00796B),
        ),
        fontFamily: "Poppins",
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

/// @author : Jibin K John
/// @date   : 04/11/2024
/// @time   : 12:35:27

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("HomeScreen"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            color: Colors.white,
          ),
          Text("Buttons"),
          FilledButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
              },
              child: Text("Continue")),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text("Are your sure"),
                      );
                    });
              },
              child: Text("Continue")),
          OutlinedButton(onPressed: () {}, child: Text("Continue")),
          TextButton(onPressed: () {}, child: Text("Continue")),
          IconButton(onPressed: () {}, icon: Icon(Icons.home_work_rounded)),
        ],
      ),
    );
  }
}
