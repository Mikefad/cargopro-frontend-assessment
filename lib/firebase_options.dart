import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // If you don't support these platforms, it's fine to throw for now.
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for this platform.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// Web options from your firebaseConfig
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCGayOI6sF3lT1EyCNcj1mfTvR0YwuNN-w',
    appId: '1:214168998538:web:e502af9161a31f566fd373',
    messagingSenderId: '214168998538',
    projectId: 'cargopro-assignment',
    authDomain: 'cargopro-assignment.firebaseapp.com',
    storageBucket: 'cargopro-assignment.firebasestorage.app',
    measurementId: 'G-D9J971LPJ5',
  );

  /// Android options (same project, Android appId)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCGayOI6sF3lT1EyCNcj1mfTvR0YwuNN-w',
    appId: '1:214168998538:android:8d5ee3c4367275036fd373',
    messagingSenderId: '214168998538',
    projectId: 'cargopro-assignment',
    storageBucket: 'cargopro-assignment.firebasestorage.app',
  );
}
