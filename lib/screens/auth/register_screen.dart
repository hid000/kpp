import 'package:flutter/material.dart';

import '../../core/auth/auth_failure.dart';
import '../../core/services/app_services.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
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
      await services.auth.signUp(
        email: _email.text,
        password: _password.text,
        displayName: '${_firstName.text.trim()} ${_lastName.text.trim()}',
      );
      await services.analytics.logSignUp();
      navigator.pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e, stackTrace) {
      await services.errors.recordError(
        e,
        stackTrace,
        reason: 'Помилка реєстрації',
      );
      if (mounted) {
        setState(
          () => _error = 'Не вдалося зареєструватися. Спробуйте пізніше.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Реєстрація',
      subtitle: 'Створіть обліковий запис Job Search',
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: "Ім'я",
                      controller: _firstName,
                      enabled: !_loading,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.givenName],
                      validator: (v) => Validators.name(v),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppTextField(
                      label: 'Прізвище',
                      controller: _lastName,
                      enabled: !_loading,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.familyName],
                      validator: (v) => Validators.name(v, field: 'Прізвище'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                helperText: 'Мінімум 8 символів, літери та цифри',
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.newPassword,
              ),
              const SizedBox(height: 30),
              PasswordField(
                controller: _confirm,
                enabled: !_loading,
                label: 'Підтвердіть пароль',
                textInputAction: TextInputAction.done,
                validator: Validators.confirmPassword(() => _password.text),
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 24),
          ErrorBanner(message: _error!),
        ],
        const SizedBox(height: 40),
        PrimaryButton(
          text: _loading ? 'Створюємо…' : 'Створити обліковий запис',
          expanded: true,
          loading: _loading,
          onPressed: _submit,
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
