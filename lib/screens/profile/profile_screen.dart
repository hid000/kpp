import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';
import '../../theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final bool confirmed = await showConfirmDialog(
      context,
      title: 'Вийти з облікового запису?',
      message: 'Щоб продовжити роботу, потрібно буде увійти знову.',
      confirmText: 'Вийти',
      destructive: true,
    );
    if (confirmed && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return AppShell(
      selectedIndex: 4,
      title: 'Профіль',
      body: PageBody(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Wrap(
                spacing: 30,
                runSpacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const InitialsAvatar(
                    text: MockData.userName,
                    size: 96,
                    filled: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MockData.userName, style: text.headlineMedium),
                      const SizedBox(height: 6),
                      Text(MockData.email, style: text.titleMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ResponsiveColumns(
            mainFlex: 3,
            sideFlex: 2,
            main: SectionCard(
              title: 'Особисті дані',
              showDivider: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: "Ім'я",
                          initialValue: MockData.firstName,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: AppTextField(
                          label: 'Прізвище',
                          initialValue: MockData.lastName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const AppTextField(
                    label: 'Електронна пошта',
                    initialValue: MockData.email,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  const AppTextField(
                    label: 'Бажана посада',
                    initialValue: 'Junior Flutter Developer',
                    prefixIcon: Icons.work,
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      text: 'Зберегти зміни',
                      icon: Icons.check,
                      onPressed: () =>
                          showInfoSnackBar(context, 'Профіль оновлено'),
                    ),
                  ),
                ],
              ),
            ),
            side: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  title: 'Безпека',
                  showDivider: false,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock),
                    title: const Text('Пароль'),
                    subtitle: const Text('Змінено 3 місяці тому'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.changePassword),
                  ),
                ),
                const SizedBox(height: 30),
                SectionCard(
                  title: 'Налаштування',
                  showDivider: false,
                  child: ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeModeNotifier,
                    builder: (context, mode, _) => SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.dark_mode),
                      title: const Text('Темна тема'),
                      value: mode == ThemeMode.dark,
                      onChanged: (dark) => themeModeNotifier.value = dark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DangerTextButton(
                    text: 'Вийти з облікового запису',
                    icon: Icons.logout,
                    onPressed: () => _logout(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
