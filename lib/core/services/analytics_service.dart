import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

/// Облік подій користувача. Екрани не залежать від конкретного сервісу.
abstract interface class AnalyticsService {
  /// Спостерігач навігації для автоматичного обліку переглядів екранів
  /// (назви беруться з назв маршрутів). `null`, якщо облік вимкнено.
  NavigatorObserver? get observer;

  Future<void> logLogin();
  Future<void> logSignUp();
  Future<void> logEvent(String name, [Map<String, Object>? parameters]);
}

/// Реалізація на Firebase Analytics.
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService([FirebaseAnalytics? analytics])
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  NavigatorObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logLogin() => _analytics.logLogin(loginMethod: 'password');

  @override
  Future<void> logSignUp() => _analytics.logSignUp(signUpMethod: 'password');

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) =>
      _analytics.logEvent(name: name, parameters: parameters);
}

/// Нічого не робить: для тестів і запуску без Firebase.
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  NavigatorObserver? get observer => null;

  @override
  Future<void> logLogin() async {}

  @override
  Future<void> logSignUp() async {}

  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {}
}
