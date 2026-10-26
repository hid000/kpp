import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Логотип Job Search: біла валіза на синьому колі.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 110});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.work, color: Colors.white, size: size * 0.5),
    );
  }
}

/// Ліва панель екранів авторизації з назвою та описом застосунку.
class BrandPanel extends StatelessWidget {
  const BrandPanel({super.key, this.compact = false});

  /// Компактний варіант для вузьких екранів (телефон).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color foreground = dark ? Colors.white : AppColors.onBrandPanel;
    final TextTheme text = Theme.of(context).textTheme;

    return ColoredBox(
      color: dark ? AppColors.brandPanelDark : AppColors.brandPanel,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: compact ? 28 : 48,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandLogo(size: compact ? 64 : 110),
              SizedBox(height: compact ? 12 : 24),
              Text(
                'Job Search',
                style: (compact ? text.headlineMedium : text.displayMedium)
                    ?.copyWith(color: foreground),
              ),
              const SizedBox(height: 12),
              Text(
                'Трекер пошуку роботи',
                style: text.titleLarge?.copyWith(color: foreground),
              ),
              if (!compact) ...[
                const SizedBox(height: 48),
                Text(
                  'Вакансії · Компанії · Співбесіди · Етапи розгляду',
                  textAlign: TextAlign.center,
                  style: text.titleMedium?.copyWith(color: foreground),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
