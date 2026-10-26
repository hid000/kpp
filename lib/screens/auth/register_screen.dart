import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      subtitle: 'Створіть обліковий запис Job Search',
      children: [
        const Row(
          children: [
            Expanded(
              child: AppTextField(
                label: "Ім'я",
                initialValue: MockData.firstName,
                textInputAction: TextInputAction.next,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: AppTextField(
                label: 'Прізвище',
                initialValue: MockData.lastName,
                textInputAction: TextInputAction.next,
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
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 30),
        const PasswordField(
          initialValue: 'password1',
          helperText: 'Мінімум 8 символів, літери та цифри',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 30),
        const PasswordField(
          label: 'Підтвердіть пароль',
          initialValue: 'password1',
        ),
        const SizedBox(height: 50),
        PrimaryButton(
          text: 'Створити обліковий запис',
          expanded: true,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          ),
        ),
        const SizedBox(height: 16),
        TextLinkRow(
          text: 'Вже маєте обліковий запис?',
          linkText: 'Увійти',
          onTap: () => Navigator.maybePop(context),
        ),
      ],
    );
  }
}
