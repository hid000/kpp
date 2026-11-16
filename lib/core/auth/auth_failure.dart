/// Помилка автентифікації з повідомленням, зрозумілим користувачеві.
class AuthFailure implements Exception {
  const AuthFailure(this.code, this.message);

  /// Код Firebase (`wrong-password`, `requires-recent-login` тощо).
  final String code;
  final String message;

  /// Firebase вимагає свіжого входу перед чутливою операцією.
  bool get requiresRecentLogin => code == 'requires-recent-login';

  /// Перетворює код помилки Firebase Auth на повідомлення українською.
  factory AuthFailure.fromCode(String code) {
    final String message = switch (code) {
      'invalid-email' => 'Некоректна адреса електронної пошти.',
      'user-disabled' => 'Цей обліковий запис заблоковано.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Не вдалося увійти. Перевірте email і пароль.',
      'email-already-in-use' =>
        'Обліковий запис із такою поштою вже існує. Спробуйте увійти.',
      'weak-password' => 'Пароль надто слабкий. Використайте щонайменше '
          '8 символів, літери та цифри.',
      'too-many-requests' =>
        'Забагато спроб. Зачекайте кілька хвилин і повторіть.',
      'network-request-failed' =>
        'Немає з’єднання з мережею. Перевірте інтернет і повторіть.',
      'requires-recent-login' =>
        'З міркувань безпеки потрібно увійти в обліковий запис знову.',
      'operation-not-allowed' =>
        'Вхід за email і паролем вимкнено в налаштуваннях Firebase.',
      _ => 'Сталася помилка автентифікації. Спробуйте ще раз.',
    };
    return AuthFailure(code, message);
  }

  @override
  String toString() => 'AuthFailure($code): $message';
}
