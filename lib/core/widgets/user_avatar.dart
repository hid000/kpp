import 'package:flutter/material.dart';

/// Кругла аватарка з ініціалами або літерою.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.text,
    this.size = 48,
    this.filled = false,
  });

  /// Ім'я або готові ініціали; беруться перші літери двох слів.
  final String text;
  final double size;

  /// true — синій фон і білий текст, false — світлий тональний фон.
  final bool filled;

  String get _initials {
    final List<String> words = text.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words.first.characters.take(2).toString();
    return words.take(2).map((w) => w.characters.first).join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? colors.primary : colors.primaryContainer,
      ),
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w500,
          color: filled ? colors.onPrimary : colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
