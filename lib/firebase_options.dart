// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDD1lJ71Q4462LvI_ZLki90CPo4F_cqf4',
    appId: '1:434782527915:web:ee72b83a475a619adfb2ee',
    messagingSenderId: '434782527915',
    projectId: 'my-budget-2600c',
    authDomain: 'my-budget-2600c.firebaseapp.com',
    databaseURL: 'https://my-budget-2600c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'my-budget-2600c.appspot.com',
    measurementId: 'G-M7CPYFFPWR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAIm8kpwBJabSieE36btSKgsDIIRi4EV0o',
    appId: '1:434782527915:android:0054c0b548cad7b8dfb2ee',
    messagingSenderId: '434782527915',
    projectId: 'my-budget-2600c',
    databaseURL: 'https://my-budget-2600c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'my-budget-2600c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAWacs5WNiLR5DueWywXT7vlruOH_xs30Q',
    appId: '1:434782527915:ios:08c24bd659b77c14dfb2ee',
    messagingSenderId: '434782527915',
    projectId: 'my-budget-2600c',
    databaseURL: 'https://my-budget-2600c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'my-budget-2600c.appspot.com',
    iosClientId: '434782527915-8kc2r5l7qrhpe7v4vrfo0g5r5tvh3v10.apps.googleusercontent.com',
    iosBundleId: 'com.codedude.myBudget',
  );
}