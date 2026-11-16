import 'package:flutter_test/flutter_test.dart';
import 'package:kpp/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('приймає коректні адреси', () {
      for (final String ok in [
        'roman.dub@lpnu.ua',
        'a+tag@example.com',
        ' user@mail.co.uk ',
      ]) {
        expect(Validators.email(ok), isNull, reason: ok);
      }
    });

    test('відхиляє порожнє значення та некоректний формат', () {
      expect(Validators.email(''), 'Введіть електронну пошту');
      expect(Validators.email(null), 'Введіть електронну пошту');
      for (final String bad in ['abc', 'a@b', '@mail.com', 'a b@mail.com']) {
        expect(Validators.email(bad), isNotNull, reason: bad);
      }
    });
  });

  group('Validators.newPassword', () {
    test('вимагає 8 символів, літеру та цифру', () {
      expect(Validators.newPassword(''), 'Введіть пароль');
      expect(Validators.newPassword('abc123'), contains('8 символів'));
      expect(Validators.newPassword('12345678'), contains('літеру'));
      expect(Validators.newPassword('abcdefgh'), contains('цифру'));
      expect(Validators.newPassword('password1'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('перевіряє збіг із початковим паролем', () {
      final validator = Validators.confirmPassword(() => 'password1');
      expect(validator(''), 'Повторіть пароль');
      expect(validator('password2'), 'Паролі не збігаються');
      expect(validator('password1'), isNull);
    });
  });

  group('Validators.name', () {
    test('обов’язкове, 2–50 символів', () {
      expect(Validators.name(' '), "Введіть ім'я");
      expect(Validators.name('А'), contains('2 символи'));
      expect(Validators.name('А' * 51), contains('50'));
      expect(Validators.name('Роман'), isNull);
      expect(Validators.name('', field: 'Прізвище'), 'Введіть прізвище');
    });
  });

  group('Validators.httpsUrl', () {
    test('приймає лише https-посилання', () {
      expect(Validators.httpsUrl('https://example.com/a.png'), isNull);
      expect(Validators.httpsUrl('http://example.com/a.png'), isNotNull);
      expect(Validators.httpsUrl('example.com'), isNotNull);
      expect(Validators.httpsUrl(''), isNotNull);
    });
  });
}
