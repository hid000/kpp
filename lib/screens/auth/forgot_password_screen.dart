import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Відновлення пароля',
      subtitle: 'Вкажіть пошту — ми надішлемо посилання для скидання пароля.',
      top: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Назад до входу'),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      children: [
        const AppTextField(
          label: 'Електронна пошта',
          initialValue: MockData.email,
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          text: 'Надіслати посилання',
          expanded: true,
          // Лист не надсилається: лише показуємо підтвердження з дизайну.
          onPressed: () => setState(() => _sent = true),
        ),
        if (_sent) ...[
          const SizedBox(height: 40),
          const SuccessBanner(
            title: 'Лист надіслано на ${MockData.email}.',
            message: 'Перевірте теку «Вхідні» або «Спам».',
          ),
        ],
      ],
    );
  }
}
