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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmGBAFIWg1G6ApFIdKY-IOl3NS5sRytlw',
    appId: '1:944944331732:android:0cedc30d995e0012c6f441',
    messagingSenderId: '944944331732',
    projectId: 'clone-re',
    storageBucket: 'clone-re.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAVxUh9vCcx_NeyC57032UsIr49BMSS9fY',
    appId: '1:944944331732:ios:3743a71b26fc45ebc6f441',
    messagingSenderId: '944944331732',
    projectId: 'clone-re',
    storageBucket: 'clone-re.appspot.com',
    androidClientId: '944944331732-5n7ihi2cp5lt3t7no68ufsta2gi6apc9.apps.googleusercontent.com',
    iosClientId: '944944331732-e5h5j7kciok43ei3lpvahuho0o0g6of8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterMealPlanner',
  );
}
