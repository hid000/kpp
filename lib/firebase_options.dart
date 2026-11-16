// УВАГА: це заготовка. Щоб підключити застосунок до свого проєкту Firebase,
// виконайте у корені проєкту `flutterfire configure` — команда перезапише цей
// файл справжніми значеннями (apiKey, appId, projectId тощо).
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
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );
}
