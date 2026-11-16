import 'package:flutter/material.dart';

import '../../core/auth/auth_failure.dart';
import '../../core/services/app_services.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final AppServices services = AppServices.of(context);
    final NavigatorState navigator = Navigator.of(context);
    setState(() => _loading = true);
    try {
      await services.auth.signIn(email: _email.text, password: _password.text);
      await services.analytics.logLogin();
      navigator.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e, stackTrace) {
      await services.errors.recordError(e, stackTrace, reason: 'Помилка входу');
      if (mounted) {
        setState(() => _error = 'Не вдалося увійти. Спробуйте пізніше.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Вхід',
      subtitle: 'Увійдіть, щоб продовжити пошук роботи',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: 'Електронна пошта',
                controller: _email,
                enabled: !_loading,
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: 30),
              PasswordField(
                controller: _password,
                enabled: !_loading,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                validator: Validators.loginPassword,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _loading
                ? null
                : () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Забули пароль?'),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 24),
        PrimaryButton(
          text: _loading ? 'Входимо…' : 'Увійти',
          expanded: true,
          loading: _loading,
          onPressed: _submit,
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
