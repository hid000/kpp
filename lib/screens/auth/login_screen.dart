import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      subtitle: 'Увійдіть, щоб продовжити пошук роботи',
      children: [
        const AppTextField(
          label: 'Електронна пошта',
          initialValue: MockData.email,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 30),
        const PasswordField(initialValue: 'password1'),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.forgotPassword),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Забули пароль?'),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          text: 'Увійти',
          expanded: true,
          // Без бізнес-логіки: вхід завжди «успішний».
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          ),
        ),
        const SizedBox(height: 16),
        TextLinkRow(
          text: 'Немає облікового запису?',
          linkText: 'Зареєструватися',
          onTap: () => Navigator.pushNamed(context, AppRoutes.register),
        ),
      ],
    );
  }
}
