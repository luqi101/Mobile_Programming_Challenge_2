// Example FlutterFire options file.
// Copy is not required manually; generate the real file with:
//
// flutterfire configure \
//   --yes \
//   --project=aadil-legal-g1-68e92 \
//   --platforms=android,web \
//   --android-package-name=com.aadilpartners.legalportfolio \
//   --out=lib/firebase_options.dart
//
// The real lib/firebase_options.dart is intentionally ignored by Git because it
// contains project-specific Firebase client API keys.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'Run FlutterFire CLI to generate lib/firebase_options.dart.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'aadil-legal-g1-68e92',
    authDomain: 'aadil-legal-g1-68e92.firebaseapp.com',
    storageBucket: 'aadil-legal-g1-68e92.firebasestorage.app',
    measurementId: 'YOUR_MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'aadil-legal-g1-68e92',
    storageBucket: 'aadil-legal-g1-68e92.firebasestorage.app',
  );
}
