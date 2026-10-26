import 'package:flutter/material.dart';

import '../core/models/vacancy.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/companies/companies_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/interviews/interviews_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/vacancies/vacancies_screen.dart';
import '../screens/vacancies/vacancy_details_screen.dart';
import '../screens/vacancies/vacancy_form_screen.dart';

abstract final class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String vacancies = '/vacancies';
  static const String companies = '/companies';
  static const String interviews = '/interviews';
  static const String profile = '/profile';

  static const String vacancyForm = '/vacancies/new';
  static const String vacancyDetails = '/vacancies/details';
  static const String changePassword = '/profile/change-password';

  /// Розділи бокової навігації, у тому ж порядку, що й у дизайні.
  static const List<String> tabs = [
    home,
    vacancies,
    companies,
    interviews,
    profile,
  ];

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget? page = switch (settings.name) {
      login => const LoginScreen(),
      register => const RegisterScreen(),
      forgotPassword => const ForgotPasswordScreen(),
      home => const HomeScreen(),
      vacancies => const VacanciesScreen(),
      companies => const CompaniesScreen(),
      interviews => const InterviewsScreen(),
      profile => const ProfileScreen(),
      vacancyForm => const VacancyFormScreen(),
      vacancyDetails => VacancyDetailsScreen(
        vacancy: settings.arguments as Vacancy?,
      ),
      changePassword => const ChangePasswordScreen(),
      _ => null,
    };
    if (page == null) return null;

    // Перемикання між розділами навігації відбувається без анімації.
    if (tabs.contains(settings.name)) {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, _, _) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}
