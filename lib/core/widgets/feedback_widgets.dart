import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Зелена плашка з повідомленням про успіх.
class SuccessBanner extends StatelessWidget {
  const SuccessBanner({super.key, required this.title, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color foreground = dark
        ? const Color(0xFFB7F0C1)
        : const Color(0xFF0B3D1A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF00531F) : AppColors.successContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.check, color: foreground),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, color: foreground)),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    message!,
                    style: TextStyle(fontSize: 13, color: foreground),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Плашка з повідомленням про помилку (невдалий вхід, зміна пароля тощо).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.action});

  final String message;

  /// Необов'язкова дія під текстом, напр. «Увійти знову».
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error, color: colors.onErrorContainer),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 15, color: colors.onErrorContainer),
                ),
                if (action != null) ...[const SizedBox(height: 8), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Плашка з повідомленням про помилку (невдалий вхід, зміна пароля тощо).
class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message, this.action});

  final String message;

  /// Необов'язкова дія під текстом, напр. «Увійти знову».
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error, color: colors.onErrorContainer),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 15, color: colors.onErrorContainer),
                ),
                if (action != null) ...[const SizedBox(height: 8), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Діалог підтвердження дії. Повертає true, якщо користувач погодився.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmText,
  String cancelText = 'Скасувати',
  bool destructive = false,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (context) {
      final ColorScheme colors = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive
                ? TextButton.styleFrom(foregroundColor: colors.error)
                : null,
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}

/// Коротке повідомлення внизу екрана.
void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}
