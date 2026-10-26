import 'package:flutter/material.dart';

import 'brand_panel.dart';

/// Каркас екранів авторизації: панель бренду зліва, форма справа.
/// На вузьких екранах панель бренду стискається і стає зверху.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.top,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  /// Елемент над заголовком, напр. посилання «Назад до входу».
  final Widget? top;

  static const double _wideBreakpoint = 840;

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    final Widget form = _AuthForm(
      title: title,
      subtitle: subtitle,
      top: top,
      children: children,
    );

    return Scaffold(
      body: wide
          ? Row(
              children: [
                const Expanded(child: BrandPanel()),
                Expanded(
                  child: SafeArea(child: Center(child: form)),
                ),
              ],
            )
          : SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [const BrandPanel(compact: true), form],
                ),
              ),
            ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({
    required this.title,
    required this.subtitle,
    required this.children,
    this.top,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (top != null) ...[top!, const SizedBox(height: 40)],
            Text(title, style: text.displaySmall),
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: text.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            ...children,
          ],
        ),
      ),
    );
  }
}
