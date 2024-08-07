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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBlB11BhuLeBc1Bp0nH6AQZU2poF7p_qqs',
    appId: '1:93586848241:web:860e1128080a49a5fcec50',
    messagingSenderId: '93586848241',
    projectId: 'purrfectmatch-abdb0',
    authDomain: 'purrfectmatch-abdb0.firebaseapp.com',
    storageBucket: 'purrfectmatch-abdb0.appspot.com',
    measurementId: 'G-HHFRLBHMH4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOO_1FYNfOnXKo8Q-ADUIgf771xNBqmos',
    appId: '1:93586848241:android:3d57a7b584bbf51dfcec50',
    messagingSenderId: '93586848241',
    projectId: 'purrfectmatch-abdb0',
    storageBucket: 'purrfectmatch-abdb0.appspot.com',
  );
}
