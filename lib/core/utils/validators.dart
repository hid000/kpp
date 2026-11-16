/// Правила локальної валідації полів форм. Кожен метод повертає текст
/// помилки або `null`, якщо значення коректне (контракт `validator`).
abstract final class Validators {
  static final RegExp _email = RegExp(
    r'^[\w.+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$',
  );

  static String? required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  /// Ім'я та прізвище: обов'язкове, 2–50 символів.
  static String? name(String? value, {String field = "Ім'я"}) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введіть ${field.toLowerCase()}';
    final int length = text.length;
    if (length < 2) return '$field має містити щонайменше 2 символи';
    if (length > 50) return '$field не може перевищувати 50 символів';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введіть електронну пошту';
    }
    if (!_email.hasMatch(value.trim())) {
      return 'Введіть коректну адресу, наприклад name@example.com';
    }
    return null;
  }

  /// Пароль при вході: лише наявність (правильність перевіряє Firebase).
  static String? loginPassword(String? value) =>
      required(value, 'Введіть пароль');

  /// Політика нового пароля: від 8 символів, літери та цифри.
  static String? newPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    if (value.length < 8) return 'Пароль має містити щонайменше 8 символів';
    if (!RegExp(r'[A-Za-zА-Яа-яІіЇїЄєҐґ]').hasMatch(value)) {
      return 'Додайте до пароля хоча б одну літеру';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Додайте до пароля хоча б одну цифру';
    }
    return null;
  }

  /// Підтвердження пароля: має збігатися з [original]().
  static String? Function(String?) confirmPassword(String Function() original) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Повторіть пароль';
      if (value != original()) return 'Паролі не збігаються';
      return null;
    };
  }

  /// Необов'язкове HTTPS-посилання на зображення.
  static String? httpsUrl(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Вставте посилання на зображення';
    final Uri? uri = Uri.tryParse(text);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return 'Посилання має починатися з https://';
    }
    return null;
  }
}
