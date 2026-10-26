import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kpp/app.dart';

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1600, 1000)
      ..devicePixelRatio = 1;
  });

  testWidgets('Застосунок відкривається на екрані входу', (tester) async {
    await tester.pumpWidget(const KppApp());
    expect(find.text('Вхід'), findsOneWidget);
    expect(find.text('Job Search'), findsOneWidget);
  });

  testWidgets('Кнопка «Увійти» відкриває головний екран', (tester) async {
    await tester.pumpWidget(const KppApp());
    await tester.tap(find.text('Увійти'));
    await tester.pumpAndSettle();
    expect(find.text('Вітаємо, Роман!'), findsOneWidget);
  });

  testWidgets('З профілю можна перейти до зміни пароля', (tester) async {
    await tester.pumpWidget(const KppApp());
    await tester.tap(find.text('Увійти'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Профіль').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Пароль'));
    await tester.pumpAndSettle();
    expect(find.text('Зміна пароля'), findsOneWidget);
  });
}
