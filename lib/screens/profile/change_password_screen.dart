import 'package:flutter/material.dart';

import '../../core/auth/auth_failure.dart';
import '../../core/services/app_services.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _current = TextEditingController();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _loading = false;
  String? _error;
  bool _needsRelogin = false;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() {
      _error = null;
      _needsRelogin = false;
    });
    if (!_formKey.currentState!.validate()) return;

    final AppServices services = AppServices.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);
    try {
      await services.auth.changePassword(
        currentPassword: _current.text,
        newPassword: _new.text,
      );
      await services.analytics.logEvent('password_changed');
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Пароль змінено'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      navigator.maybePop();
    } on AuthFailure catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _needsRelogin = e.requiresRecentLogin;
        });
      }
    } catch (e, stackTrace) {
      await services.errors.recordError(
        e,
        stackTrace,
        reason: 'Помилка зміни пароля',
      );
      if (mounted) {
        setState(() => _error = 'Не вдалося змінити пароль. Спробуйте пізніше.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Для `requires-recent-login`: завершує сеанс і повертає на екран входу.
  Future<void> _signInAgain() async {
    final NavigatorState navigator = Navigator.of(context);
    await AppServices.of(context).auth.signOut();
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Новий пароль', style: text.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'Для підтвердження особи введіть поточний пароль.',
                          style: text.bodyMedium,
                        ),
                        const SizedBox(height: 40),
                        PasswordField(
                          label: 'Поточний пароль',
                          controller: _current,
                          enabled: !_loading,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.password],
                          validator: Validators.loginPassword,
                        ),
                        const SizedBox(height: 30),
                        PasswordField(
                          label: 'Новий пароль',
                          controller: _new,
                          enabled: !_loading,
                          helperText: 'Мінімум 8 символів, літери та цифри',
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (v) {
                            final String? problem = Validators.newPassword(v);
                            if (problem != null) return problem;
                            return v == _current.text
                                ? 'Новий пароль має відрізнятися від поточного'
                                : null;
                          },
                        ),
                        const SizedBox(height: 30),
                        PasswordField(
                          label: 'Підтвердіть новий пароль',
                          controller: _confirm,
                          enabled: !_loading,
                          textInputAction: TextInputAction.done,
                          validator: Validators.confirmPassword(() => _new.text),
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 30),
                          ErrorBanner(
                            message: _error!,
                            action: _needsRelogin
                                ? TextButton(
                                    onPressed: _signInAgain,
                                    child: const Text('Увійти знову'),
                                  )
                                : null,
                          ),
                        ],
                        const SizedBox(height: 40),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 20,
                          runSpacing: 12,
                          children: [
                            SecondaryButton(
                              text: 'Скасувати',
                              onPressed: _loading
                                  ? null
                                  : () => Navigator.maybePop(context),
                            ),
                            PrimaryButton(
                              text: _loading ? 'Зберігаємо…' : 'Змінити пароль',
                              icon: Icons.check,
                              loading: _loading,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ],
                    ),
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
