import 'package:flutter/material.dart';

import '../../core/auth/auth_failure.dart';
import '../../core/services/app_services.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  bool _loading = false;
  String? _sentTo;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() {
      _error = null;
      _sentTo = null;
    });
    if (!_formKey.currentState!.validate()) return;

    final AppServices services = AppServices.of(context);
    final String email = _email.text.trim();
    setState(() => _loading = true);
    try {
      await services.auth.sendPasswordResetEmail(email: email);
      await services.analytics.logEvent('password_reset_requested');
      if (mounted) setState(() => _sentTo = email);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e, stackTrace) {
      await services.errors.recordError(
        e,
        stackTrace,
        reason: 'Помилка відновлення пароля',
      );
      if (mounted) {
        setState(
          () => _error = 'Не вдалося надіслати лист. Спробуйте пізніше.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
        Form(
          key: _formKey,
          child: AppTextField(
            label: 'Електронна пошта',
            controller: _email,
            enabled: !_loading,
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: Validators.email,
            onFieldSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          text: _loading ? 'Надсилаємо…' : 'Надіслати посилання',
          expanded: true,
          loading: _loading,
          onPressed: _submit,
        ),
        if (_error != null) ...[
          const SizedBox(height: 24),
          ErrorBanner(message: _error!),
        ],
        if (_sentTo != null) ...[
          const SizedBox(height: 40),
          SuccessBanner(
            title: 'Лист надіслано на $_sentTo.',
            message: 'Перевірте теку «Вхідні» або «Спам».',
          ),
        ],
      ],
    );
  }
}
