// Згенеровано `flutterfire configure` для проєкту kpp-lab-711a4 (лише web).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Для цієї платформи Firebase не налаштовано. '
      'Запустіть `flutterfire configure`.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCdKv_CvYOCJazANws7iFp2lw-DEtg2Q3s',
    appId: '1:493438792724:web:5b515240b38b028922a301',
    messagingSenderId: '493438792724',
    projectId: 'kpp-lab-711a4',
    authDomain: 'kpp-lab-711a4.firebaseapp.com',
    storageBucket: 'kpp-lab-711a4.firebasestorage.app',
    measurementId: 'G-NTW560DKFB',
  );
}
