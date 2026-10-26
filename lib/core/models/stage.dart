import 'package:flutter/material.dart';

/// Етап розгляду заявки на вакансію.
enum Stage {
  saved('Збережено'),
  applied('Подано'),
  testTask('Тестове завдання'),
  interview('Співбесіда'),
  offer('Пропозиція'),
  rejected('Відмова');

  const Stage(this.label);

  final String label;

  /// Основний колір етапу (смуга у воронці, текст чипа).
  Color color(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;
    return switch (this) {
      Stage.saved => dark ? const Color(0xFFC4C6D0) : const Color(0xFF44474F),
      Stage.applied => dark ? const Color(0xFFA9C7FF) : const Color(0xFF1F5AA6),
      Stage.testTask =>
        dark ? const Color(0xFFF5C445) : const Color(0xFF7A5A00),
      Stage.interview =>
        dark ? const Color(0xFFD7BAFF) : const Color(0xFF6F42C1),
      Stage.offer => dark ? const Color(0xFF8CD99B) : const Color(0xFF1E7D3A),
      Stage.rejected =>
        dark ? const Color(0xFFFFB4AB) : const Color(0xFFC62828),
    };
  }

  /// Фон чипа етапу.
  Color containerColor(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;
    return switch (this) {
      Stage.saved => dark ? const Color(0xFF44474F) : const Color(0xFFE1E2EC),
      Stage.applied => dark ? const Color(0xFF00458F) : const Color(0xFFD6E3FF),
      Stage.testTask =>
        dark ? const Color(0xFF5C4300) : const Color(0xFFFFDEA0),
      Stage.interview =>
        dark ? const Color(0xFF5A2DA8) : const Color(0xFFEADDFF),
      Stage.offer => dark ? const Color(0xFF00531F) : const Color(0xFFB7F0C1),
      Stage.rejected =>
        dark ? const Color(0xFF93000A) : const Color(0xFFFFDAD6),
    };
  }
}
