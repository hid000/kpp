import 'package:flutter/material.dart';

/// Стилізоване поле введення з підписом на рамці (Material 3 outlined).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String? initialValue;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        alignLabelWithHint: maxLines > 1,
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(prefixIcon),
              ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Поле для пароля з кнопкою «показати/сховати».
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.label = 'Пароль',
    this.initialValue,
    this.helperText,
    this.textInputAction,
  });

  final String label;
  final String? initialValue;
  final String? helperText;
  final TextInputAction? textInputAction;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      obscureText: _obscured,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.lock),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            tooltip: _obscured ? 'Показати пароль' : 'Сховати пароль',
            icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscured = !_obscured),
          ),
        ),
      ),
    );
  }
}

/// Випадний список у стилі інших полів.
class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.initialValue,
  });

  final String label;
  final List<String> items;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(item)),
      ],
      onChanged: (_) {},
    );
  }
}

/// Поле пошуку зі значком лупи та необов'язковою підказкою гарячої клавіші.
class AppSearchField extends StatelessWidget {
  const AppSearchField({super.key, required this.hint, this.shortcut});

  final String hint;
  final String? shortcut;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return TextField(
      decoration: InputDecoration(
        labelText: 'Пошук',
        hintText: hint,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.search),
        ),
        suffixIcon: shortcut == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Chip(
                  label: Text(shortcut!),
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: colors.surfaceContainerHigh,
                  side: BorderSide(color: colors.outlineVariant),
                ),
              ),
      ),
    );
  }
}
