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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDMliOX33S4Ad32wlaDahif3RtASZ4SBnA',
    appId: '1:339472854852:web:29f647d11f9a3d23b33111',
    messagingSenderId: '339472854852',
    projectId: 'decorar-studio0',
    authDomain: 'decorar-studio0.firebaseapp.com',
    databaseURL:
        'https://decorar-studio0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'decorar-studio0.appspot.com',
    measurementId: 'G-KTRYYDY81J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDg-BqQJvX4fonZt9LGCY8NIJFwpcN4_Vg',
    appId: '1:339472854852:android:30f2d54016ebfc8ab33111',
    messagingSenderId: '339472854852',
    projectId: 'decorar-studio0',
    databaseURL:
        'https://decorar-studio0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'decorar-studio0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDajxYdIBw0NwqM9I-Fhg-mC2H2yHMrkCA',
    appId: '1:339472854852:ios:45c646f8625ab19eb33111',
    messagingSenderId: '339472854852',
    projectId: 'decorar-studio0',
    databaseURL:
        'https://decorar-studio0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'decorar-studio0.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDajxYdIBw0NwqM9I-Fhg-mC2H2yHMrkCA',
    appId: '1:339472854852:ios:45c646f8625ab19eb33111',
    messagingSenderId: '339472854852',
    projectId: 'decorar-studio0',
    databaseURL:
        'https://decorar-studio0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'decorar-studio0.appspot.com',
    iosBundleId: 'com.example.finalProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDMliOX33S4Ad32wlaDahif3RtASZ4SBnA',
    appId: '1:339472854852:web:7ed6454aca04655fb33111',
    messagingSenderId: '339472854852',
    projectId: 'decorar-studio0',
    authDomain: 'decorar-studio0.firebaseapp.com',
    databaseURL:
        'https://decorar-studio0-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'decorar-studio0.appspot.com',
    measurementId: 'G-2GHBYFY6MY',
  );
}
