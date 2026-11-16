import 'package:flutter/widgets.dart';

import '../auth/auth_repository.dart';
import 'analytics_service.dart';
import 'error_reporter.dart';

/// Надає екранам сервіси застосунку. У тестах підставляються підробки.
class AppServices extends InheritedWidget {
  const AppServices({
    super.key,
    required this.auth,
    required this.analytics,
    required this.errors,
    required super.child,
  });

  final AuthRepository auth;
  final AnalyticsService analytics;
  final ErrorReporter errors;

  static AppServices of(BuildContext context) {
    final AppServices? services = context
        .dependOnInheritedWidgetOfExactType<AppServices>();
    assert(services != null, 'AppServices не знайдено вище в дереві віджетів');
    return services!;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) =>
      auth != oldWidget.auth ||
      analytics != oldWidget.analytics ||
      errors != oldWidget.errors;
}
