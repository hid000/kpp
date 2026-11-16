import 'package:flutter/material.dart';

import 'core/services/app_services.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class KppApp extends StatelessWidget {
  const KppApp({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorObserver? analyticsObserver = AppServices.of(
      context,
    ).analytics.observer;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => MaterialApp(
        title: 'Job Search',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: mode,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorObservers: [?analyticsObserver],
      ),
    );
  }
}
