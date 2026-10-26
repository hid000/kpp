import 'package:flutter/material.dart';

/// Основна кнопка підтвердження дії (заповнена, у формі «пігулки»).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final Widget button = icon == null
        ? FilledButton(onPressed: onPressed, child: Text(text))
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text),
          );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Другорядна кнопка (скасування, альтернативна дія).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final Widget button = icon == null
        ? OutlinedButton(onPressed: onPressed, child: Text(text))
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text),
          );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Небезпечна текстова дія, напр. «Видалити».
class DangerTextButton extends StatelessWidget {
  const DangerTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.error;
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(64, 52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      icon: icon == null ? null : Icon(icon),
      label: Text(text),
    );
  }
}

/// Рядок «Текст? Посилання» під формами авторизації.
class TextLinkRow extends StatelessWidget {
  const TextLinkRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(textStyle: const TextStyle(fontSize: 16)),
          child: Text(linkText),
        ),
      ],
    );
  }
}

/// Кнопки «Редагувати» та «Видалити» для рядків таблиць і карток.
class EditDeleteActions extends StatelessWidget {
  const EditDeleteActions({super.key, this.onEdit, this.onDelete});

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Редагувати',
          icon: const Icon(Icons.edit),
          onPressed: onEdit ?? () {},
        ),
        IconButton(
          tooltip: 'Видалити',
          icon: const Icon(Icons.delete),
          onPressed: onDelete ?? () {},
        ),
      ],
    );
  }
}
