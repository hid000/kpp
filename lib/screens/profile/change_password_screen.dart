import 'package:flutter/material.dart';

import '../../core/widgets/widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return AppShell(
      selectedIndex: 4,
      title: 'Зміна пароля',
      showBack: true,
      body: PageBody(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Новий пароль', style: text.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        'Після зміни пароля потрібно буде увійти знову на '
                        'інших пристроях.',
                        style: text.bodyMedium,
                      ),
                      const SizedBox(height: 40),
                      const PasswordField(
                        label: 'Поточний пароль',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 30),
                      const PasswordField(
                        label: 'Новий пароль',
                        helperText: 'Мінімум 8 символів, літери та цифри',
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 30),
                      const PasswordField(label: 'Підтвердіть новий пароль'),
                      const SizedBox(height: 50),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 20,
                        runSpacing: 12,
                        children: [
                          SecondaryButton(
                            text: 'Скасувати',
                            onPressed: () => Navigator.maybePop(context),
                          ),
                          PrimaryButton(
                            text: 'Змінити пароль',
                            icon: Icons.check,
                            onPressed: () {
                              showInfoSnackBar(context, 'Пароль змінено');
                              Navigator.maybePop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
