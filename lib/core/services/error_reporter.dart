import 'package:sentry_flutter/sentry_flutter.dart';

/// Надсилання звітів про помилки. Firebase Crashlytics не підтримує Web,
/// тому для цієї платформи використано Sentry.
abstract interface class ErrorReporter {
  /// Реєструє помилку, яку застосунок обробив і продовжив роботу (non-fatal).
  Future<void> recordError(Object error, StackTrace stackTrace, {String? reason});
}

class SentryErrorReporter implements ErrorReporter {
  const SentryErrorReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: reason == null ? null : Hint.withMap({'reason': reason}),
    );
  }
}

/// Нічого не робить: для тестів.
class NoopErrorReporter implements ErrorReporter {
  const NoopErrorReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
  }) async {}
}
