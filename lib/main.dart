import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/auth/auth_repository.dart';
import 'core/services/analytics_service.dart';
import 'core/services/app_services.dart';
import 'core/services/error_reporter.dart';
import 'firebase_options.dart';

/// DSN проєкту Sentry; передається під час запуску:
/// `flutter run -d chrome --dart-define=SENTRY_DSN=https://...`
/// Без DSN Sentry вимкнено.
const String _sentryDsn = String.fromEnvironment('SENTRY_DSN');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SentryFlutter.init підключає FlutterError.onError та
  // PlatformDispatcher.instance.onError і запускає застосунок.
  await SentryFlutter.init(
    (options) {
      options.dsn = _sentryDsn;
      options.tracesSampleRate = 0;
    },
    appRunner: () => runApp(
      AppServices(
        auth: FirebaseAuthRepository(),
        analytics: FirebaseAnalyticsService(),
        errors: const SentryErrorReporter(),
        child: const KppApp(),
      ),
    ),
  );
}
