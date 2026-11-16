import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kpp/app.dart';
import 'package:kpp/core/services/analytics_service.dart';
import 'package:kpp/core/services/app_services.dart';
import 'package:kpp/core/services/error_reporter.dart';
import 'package:kpp/screens/profile/widgets/photo_picker_dialog.dart';

import 'fakes/fake_auth_repository.dart';

Widget _app(FakeAuthRepository auth) => AppServices(
  auth: auth,
  analytics: const NoopAnalyticsService(),
  errors: const NoopErrorReporter(),
  child: const KppApp(),
);

Future<void> _pump(WidgetTester tester, FakeAuthRepository auth) async {
  await tester.pumpWidget(_app(auth));
  await tester.pumpAndSettle();
}

Finder _field(String label) => find.widgetWithText(TextFormField, label);

Future<void> _signIn(
  WidgetTester tester, {
  String email = FakeAuthRepository.seedEmail,
  String password = FakeAuthRepository.seedPassword,
}) async {
  await tester.enterText(_field('Електронна пошта'), email);
  await tester.enterText(_field('Пароль'), password);
  await tester.tap(find.text('Увійти'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1600, 1200)
      ..devicePixelRatio = 1;
  });

  group('Сеанс', () {
    testWidgets('без входу відкривається екран входу', (tester) async {
      await _pump(tester, FakeAuthRepository());
      expect(find.text('Вхід'), findsOneWidget);
    });

    testWidgets('збережений сеанс одразу відкриває головний екран', (
      tester,
    ) async {
      await _pump(tester, FakeAuthRepository(signedIn: true));
      expect(find.text('Вітаємо, Роман!'), findsOneWidget);
    });
  });

  group('Вхід', () {
    testWidgets('порожня форма показує помилки валідації', (tester) async {
      await _pump(tester, FakeAuthRepository());
      await tester.tap(find.text('Увійти'));
      await tester.pumpAndSettle();
      expect(find.text('Введіть електронну пошту'), findsOneWidget);
      expect(find.text('Введіть пароль'), findsOneWidget);
    });

    testWidgets('некоректний email не надсилається на сервер', (tester) async {
      final auth = FakeAuthRepository();
      await _pump(tester, auth);
      await _signIn(tester, email: 'abc');
      expect(find.textContaining('коректну адресу'), findsOneWidget);
      expect(auth.currentUser, isNull);
    });

    testWidgets('неправильний пароль показує зрозумілу помилку', (
      tester,
    ) async {
      final auth = FakeAuthRepository();
      await _pump(tester, auth);
      await _signIn(tester, password: 'wrongpass1');
      expect(
        find.text('Не вдалося увійти. Перевірте email і пароль.'),
        findsOneWidget,
      );
      expect(auth.currentUser, isNull);
    });

    testWidgets('успішний вхід відкриває головний екран', (tester) async {
      final auth = FakeAuthRepository();
      await _pump(tester, auth);
      await _signIn(tester);
      expect(find.text('Вітаємо, Роман!'), findsOneWidget);
      expect(auth.currentUser?.email, FakeAuthRepository.seedEmail);
    });

    testWidgets('під час запиту кнопка заблокована від повторного натискання', (
      tester,
    ) async {
      final auth = FakeAuthRepository(delay: const Duration(seconds: 1));
      await _pump(tester, auth);
      await tester.enterText(
        _field('Електронна пошта'),
        FakeAuthRepository.seedEmail,
      );
      await tester.enterText(_field('Пароль'), FakeAuthRepository.seedPassword);
      await tester.tap(find.text('Увійти'));
      await tester.pump();
      expect(find.text('Входимо…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
      await tester.pumpAndSettle();
      expect(find.text('Вітаємо, Роман!'), findsOneWidget);
    });

    testWidgets('помилка мережі описана зрозуміло', (tester) async {
      final auth = FakeAuthRepository(failWith: 'network-request-failed');
      await _pump(tester, auth);
      await _signIn(tester);
      expect(find.textContaining('Немає з’єднання'), findsOneWidget);
    });
  });

  group('Реєстрація', () {
    Future<void> openRegister(WidgetTester tester, FakeAuthRepository a) async {
      await _pump(tester, a);
      await tester.tap(find.text('Зареєструватися'));
      await tester.pumpAndSettle();
    }

    testWidgets('валідує всі поля', (tester) async {
      await openRegister(tester, FakeAuthRepository());
      await tester.enterText(_field('Електронна пошта'), 'abc');
      await tester.enterText(_field('Пароль'), 'short');
      await tester.enterText(_field('Підтвердіть пароль'), 'other');
      await tester.tap(find.text('Створити обліковий запис'));
      await tester.pumpAndSettle();
      expect(find.text("Введіть ім'я"), findsOneWidget);
      expect(find.text('Введіть прізвище'), findsOneWidget);
      expect(find.textContaining('коректну адресу'), findsOneWidget);
      expect(find.textContaining('8 символів'), findsWidgets);
      expect(find.text('Паролі не збігаються'), findsOneWidget);
    });

    testWidgets('успішна реєстрація створює обліковий запис', (tester) async {
      final auth = FakeAuthRepository();
      await openRegister(tester, auth);
      await tester.enterText(_field("Ім'я"), 'Олена');
      await tester.enterText(_field('Прізвище'), 'Коваль');
      await tester.enterText(_field('Електронна пошта'), 'olena@example.com');
      await tester.enterText(_field('Пароль'), 'secret123');
      await tester.enterText(_field('Підтвердіть пароль'), 'secret123');
      await tester.tap(find.text('Створити обліковий запис'));
      await tester.pumpAndSettle();
      expect(find.text('Вітаємо, Олена!'), findsOneWidget);
      expect(auth.currentUser?.name, 'Олена Коваль');
    });

    testWidgets('зайнятий email показує помилку', (tester) async {
      final auth = FakeAuthRepository();
      await openRegister(tester, auth);
      await tester.enterText(_field("Ім'я"), 'Роман');
      await tester.enterText(_field('Прізвище'), 'Дуб');
      await tester.enterText(
        _field('Електронна пошта'),
        FakeAuthRepository.seedEmail,
      );
      await tester.enterText(_field('Пароль'), 'secret123');
      await tester.enterText(_field('Підтвердіть пароль'), 'secret123');
      await tester.tap(find.text('Створити обліковий запис'));
      await tester.pumpAndSettle();
      expect(find.textContaining('вже існує'), findsOneWidget);
    });
  });

  group('Відновлення пароля', () {
    Future<void> openForgot(WidgetTester tester, FakeAuthRepository a) async {
      await _pump(tester, a);
      await tester.tap(find.text('Забули пароль?'));
      await tester.pumpAndSettle();
    }

    testWidgets('надсилає лист і показує підтвердження', (tester) async {
      final auth = FakeAuthRepository();
      await openForgot(tester, auth);
      await tester.enterText(
        _field('Електронна пошта'),
        FakeAuthRepository.seedEmail,
      );
      await tester.tap(find.text('Надіслати посилання'));
      await tester.pumpAndSettle();
      expect(auth.resetEmails, [FakeAuthRepository.seedEmail]);
      expect(
        find.text('Лист надіслано на ${FakeAuthRepository.seedEmail}.'),
        findsOneWidget,
      );
    });

    testWidgets('не надсилає запит із некоректним email', (tester) async {
      final auth = FakeAuthRepository();
      await openForgot(tester, auth);
      await tester.enterText(_field('Електронна пошта'), 'abc');
      await tester.tap(find.text('Надіслати посилання'));
      await tester.pumpAndSettle();
      expect(auth.resetEmails, isEmpty);
      expect(find.textContaining('коректну адресу'), findsOneWidget);
    });
  });

  group('Профіль', () {
    Future<void> openProfile(WidgetTester tester, FakeAuthRepository a) async {
      await _pump(tester, a);
      await tester.tap(find.text('Профіль').first);
      await tester.pumpAndSettle();
    }

    testWidgets('показує дані користувача та зберігає нове ім’я', (
      tester,
    ) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openProfile(tester, auth);
      expect(find.text(FakeAuthRepository.seedEmail), findsWidgets);
      await tester.enterText(_field("Ім'я"), 'Ромко');
      await tester.tap(find.text('Зберегти зміни'));
      await tester.pumpAndSettle();
      expect(auth.currentUser?.name, 'Ромко Дуб');
      expect(find.text('Профіль оновлено'), findsOneWidget);
    });

    testWidgets('порожнє ім’я не зберігається', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openProfile(tester, auth);
      await tester.enterText(_field("Ім'я"), '');
      await tester.tap(find.text('Зберегти зміни'));
      await tester.pumpAndSettle();
      expect(find.text("Введіть ім'я"), findsOneWidget);
      expect(auth.currentUser?.name, 'Роман Дуб');
    });

    testWidgets('діалог фото дозволяє вибрати зображення й зберегти його', (
      tester,
    ) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openProfile(tester, auth);
      await tester.tap(find.text('Змінити фото'));
      await tester.pumpAndSettle();
      expect(find.text('Фото профілю'), findsOneWidget);
      // Поки нічого не вибрано, кнопка «Зберегти» неактивна.
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Зберегти'))
            .onPressed,
        isNull,
      );
      await tester.tap(find.byKey(ValueKey(presetAvatarUrls.first)));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Зберегти'));
      await tester.pumpAndSettle();
      expect(auth.currentUser?.photoUrl, presetAvatarUrls.first);
    });

    testWidgets('власне посилання без https не приймається', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openProfile(tester, auth);
      await tester.tap(find.text('Змінити фото'));
      await tester.pumpAndSettle();
      await tester.enterText(
        _field('HTTPS-посилання'),
        'http://example.com/a.png',
      );
      await tester.tap(find.text('Показати'));
      await tester.pumpAndSettle();
      expect(find.textContaining('https://'), findsWidgets);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Зберегти'))
            .onPressed,
        isNull,
      );
    });

    testWidgets('вихід повертає на екран входу', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openProfile(tester, auth);
      await tester.tap(find.text('Вийти з облікового запису'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Вийти'));
      await tester.pumpAndSettle();
      expect(find.text('Вхід'), findsOneWidget);
      expect(auth.currentUser, isNull);
    });
  });

  group('Зміна пароля', () {
    Future<void> openChange(WidgetTester tester, FakeAuthRepository a) async {
      await _pump(tester, a);
      await tester.tap(find.text('Профіль').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Пароль'));
      await tester.pumpAndSettle();
    }

    Future<void> fill(WidgetTester tester, String current, String next) async {
      await tester.enterText(_field('Поточний пароль'), current);
      await tester.enterText(_field('Новий пароль'), next);
      await tester.enterText(_field('Підтвердіть новий пароль'), next);
      await tester.tap(find.text('Змінити пароль'));
      await tester.pumpAndSettle();
    }

    testWidgets('успішно змінює пароль', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openChange(tester, auth);
      await fill(tester, FakeAuthRepository.seedPassword, 'newpass123');
      expect(auth.passwordOf(FakeAuthRepository.seedEmail), 'newpass123');
      expect(find.text('Пароль змінено'), findsOneWidget);
    });

    testWidgets('неправильний поточний пароль показує помилку', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openChange(tester, auth);
      await fill(tester, 'wrongpass1', 'newpass123');
      expect(find.text('Поточний пароль введено неправильно.'), findsOneWidget);
      expect(
        auth.passwordOf(FakeAuthRepository.seedEmail),
        FakeAuthRepository.seedPassword,
      );
    });

    testWidgets('requires-recent-login пропонує увійти знову', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openChange(tester, auth);
      auth.failWith = 'requires-recent-login';
      await fill(tester, FakeAuthRepository.seedPassword, 'newpass123');
      expect(
        find.textContaining('увійти в обліковий запис знову'),
        findsOneWidget,
      );
      await tester.tap(find.text('Увійти знову'));
      await tester.pumpAndSettle();
      expect(find.text('Вхід'), findsOneWidget);
      expect(auth.currentUser, isNull);
    });

    testWidgets('новий пароль має відрізнятися від поточного', (tester) async {
      final auth = FakeAuthRepository(signedIn: true);
      await openChange(tester, auth);
      await fill(
        tester,
        FakeAuthRepository.seedPassword,
        FakeAuthRepository.seedPassword,
      );
      expect(find.textContaining('відрізнятися'), findsOneWidget);
    });
  });
}
