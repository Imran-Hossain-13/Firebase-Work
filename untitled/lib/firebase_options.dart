// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyD4pU_I9eI3JVQp_NeJbu0vh8Xfumqib20',
    appId: '1:185643184467:web:cc97192adf048590efb1a6',
    messagingSenderId: '185643184467',
    projectId: 'practice-8f493',
    authDomain: 'practice-8f493.firebaseapp.com',
    storageBucket: 'practice-8f493.appspot.com',
    measurementId: 'G-KGJCY9S7GD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9AS_wfDANbM1ex9oK5bPaehDcqqUTU8U',
    appId: '1:185643184467:android:a30bede3cb7d4c61efb1a6',
    messagingSenderId: '185643184467',
    projectId: 'practice-8f493',
    storageBucket: 'practice-8f493.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD22y4d4DV0GIQTncjl0s6IdXYvjp_ABQo',
    appId: '1:185643184467:ios:f0dd5917166fd5e8efb1a6',
    messagingSenderId: '185643184467',
    projectId: 'practice-8f493',
    storageBucket: 'practice-8f493.appspot.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD22y4d4DV0GIQTncjl0s6IdXYvjp_ABQo',
    appId: '1:185643184467:ios:0e7cd22370a54bc6efb1a6',
    messagingSenderId: '185643184467',
    projectId: 'practice-8f493',
    storageBucket: 'practice-8f493.appspot.com',
    iosBundleId: 'com.example.untitled.RunnerTests',
  );
}
