import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../data/mock_data.dart';
import 'user_avatar.dart';

/// Пункт бокової навігації.
class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

const List<_NavItem> _navItems = [
  _NavItem('Головна', Icons.home),
  _NavItem('Вакансії', Icons.work),
  _NavItem('Компанії', Icons.domain),
  _NavItem('Співбесіди', Icons.event),
  _NavItem('Профіль', Icons.person),
];

/// Каркас основних екранів: бокова навігація (на телефоні — нижня),
/// верхня панель із заголовком та аватаркою користувача.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.selectedIndex,
    required this.title,
    required this.body,
    this.showBack = false,
    this.floatingActionButton,
  });

  /// Індекс розділу у [AppRoutes.tabs].
  final int selectedIndex;
  final String title;
  final Widget body;
  final bool showBack;
  final Widget? floatingActionButton;

  static const double _railBreakpoint = 600;

  void _openTab(BuildContext context, int index) {
    if (index == selectedIndex && !showBack) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.tabs[index],
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool wide = MediaQuery.sizeOf(context).width >= _railBreakpoint;
    final ColorScheme colors = Theme.of(context).colorScheme;

    final Widget content = Column(
      children: [
        _TopBar(title: title, showBack: showBack),
        const Divider(),
        Expanded(child: body),
      ],
    );

    if (!wide) {
      return Scaffold(
        body: SafeArea(child: content),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (i) => _openTab(context, i),
          destinations: [
            for (final item in _navItems)
              NavigationDestination(icon: Icon(item.icon), label: item.label),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => _openTab(context, i),
              minWidth: 100,
              groupAlignment: -1,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: InitialsAvatar(
                  text: 'JS',
                  size: 50,
                  filled: colors.brightness == Brightness.light,
                ),
              ),
              destinations: [
                for (final item in _navItems)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
              ],
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.showBack});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            if (showBack) ...[
              IconButton(
                tooltip: 'Назад',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.maybePop(context),
              ),
              const SizedBox(width: 8),
            ] else
              const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.profile,
                (_) => false,
              ),
              child: InitialsAvatar(
                text: MockData.userName,
                size: 46,
                filled: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Прокручуваний вміст сторінки зі стандартними відступами.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final bool narrow = MediaQuery.sizeOf(context).width < 600;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: narrow ? 16 : 40,
        vertical: narrow ? 16 : 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
