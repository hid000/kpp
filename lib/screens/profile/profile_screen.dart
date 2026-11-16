import 'package:flutter/material.dart';

import '../../core/auth/app_user.dart';
import '../../core/auth/auth_failure.dart';
import '../../core/services/app_services.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/widgets.dart';
import '../../routes/app_routes.dart';
import '../../theme/theme_controller.dart';
import 'widgets/photo_picker_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  bool _initialized = false;
  bool _saving = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final AppUser? user = AppServices.of(context).auth.currentUser;
    _firstName.text = user?.firstName ?? '';
    _lastName.text = user?.lastName ?? '';
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  /// Виконує зміну профілю, показує результат і повертає true при успіху.
  Future<bool> _run(
    Future<void> Function(AppServices services) action, {
    required String success,
    required String reason,
  }) async {
    final AppServices services = AppServices.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await action(services);
      if (mounted) showInfoSnackBar(context, success);
      return true;
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e, stackTrace) {
      await services.errors.recordError(e, stackTrace, reason: reason);
      if (mounted) setState(() => _error = 'Не вдалося зберегти зміни.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    return false;
  }

  Future<void> _saveProfile() async {
    if (_saving || !_formKey.currentState!.validate()) return;
    final String name = '${_firstName.text.trim()} ${_lastName.text.trim()}'
        .trim();
    final bool ok = await _run(
      (s) => s.auth.updateProfile(displayName: name),
      success: 'Профіль оновлено',
      reason: 'Помилка оновлення профілю',
    );
    if (ok && mounted) {
      await AppServices.of(context).analytics.logEvent('profile_updated');
    }
  }

  Future<void> _changePhoto(AppUser user) async {
    final String? url = await showPhotoPickerDialog(
      context,
      name: user.name,
      currentUrl: user.photoUrl,
    );
    if (url == null || !mounted) return;
    final bool ok = await _run(
      (s) => s.auth.updateProfile(photoUrl: url),
      success: url.isEmpty ? 'Фото прибрано' : 'Фото оновлено',
      reason: 'Помилка оновлення фото',
    );
    if (ok && mounted) {
      await AppServices.of(context).analytics.logEvent('photo_changed');
    }
  }

  Future<void> _logout() async {
    final bool confirmed = await showConfirmDialog(
      context,
      title: 'Вийти з облікового запису?',
      message: 'Щоб продовжити роботу, потрібно буде увійти знову.',
      confirmText: 'Вийти',
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final NavigatorState navigator = Navigator.of(context);
    final AppServices services = AppServices.of(context);
    await services.auth.signOut();
    await services.analytics.logEvent('logout');
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final AppServices services = AppServices.of(context);

    return StreamBuilder<AppUser?>(
      stream: services.auth.userChanges(),
      initialData: services.auth.currentUser,
      builder: (context, snapshot) {
        final AppUser? user = snapshot.data;
        if (user == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
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
                      PhotoAvatar(
                        name: user.name,
                        photoUrl: user.photoUrl,
                        size: 96,
                        filled: true,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name, style: text.headlineMedium),
                          const SizedBox(height: 6),
                          Text(user.email, style: text.titleMedium),
                          const SizedBox(height: 12),
                          SecondaryButton(
                            text: 'Змінити фото',
                            icon: Icons.photo_camera,
                            onPressed: _saving ? null : () => _changePhoto(user),
                          ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: "Ім'я",
                                controller: _firstName,
                                enabled: !_saving,
                                validator: (v) => Validators.name(v),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: AppTextField(
                                label: 'Прізвище',
                                controller: _lastName,
                                enabled: !_saving,
                                validator: (v) =>
                                    Validators.name(v, field: 'Прізвище'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        AppTextField(
                          label: 'Електронна пошта',
                          initialValue: user.email,
                          prefixIcon: Icons.email,
                          readOnly: true,
                          helperText: 'Адресу пошти змінити не можна',
                        ),
                        const SizedBox(height: 30),
                        // Заглушка: дані поза Firebase Auth зберігатимуться
                        // після інтеграції з Cloud Firestore.
                        const AppTextField(
                          label: 'Бажана посада',
                          initialValue: 'Junior Flutter Developer',
                          prefixIcon: Icons.work,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 30),
                          ErrorBanner(message: _error!),
                        ],
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton(
                            text: _saving ? 'Зберігаємо…' : 'Зберегти зміни',
                            icon: Icons.check,
                            loading: _saving,
                            onPressed: _saveProfile,
                          ),
                        ),
                      ],
                    ),
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
                        subtitle: const Text('Змінити пароль входу'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.changePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SectionCard(
                      title: 'Налаштування',
                      showDivider: false,
                      child: Column(
                        children: [
                          ValueListenableBuilder<ThemeMode>(
                            valueListenable: themeModeNotifier,
                            builder: (context, mode, _) => SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              secondary: const Icon(Icons.dark_mode),
                              title: const Text('Темна тема'),
                              value: mode == ThemeMode.dark,
                              onChanged: (dark) => themeModeNotifier.value =
                                  dark ? ThemeMode.dark : ThemeMode.light,
                            ),
                          ),
                          // Лише для лабораторної роботи: перевірка звітів Sentry.
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.bug_report),
                            title: const Text('Згенерувати тестову помилку'),
                            subtitle: const Text('Перевірка звітів Sentry'),
                            onTap: () => throw StateError(
                              'Тестова помилка для перевірки Sentry (ЛР №4)',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DangerTextButton(
                        text: 'Вийти з облікового запису',
                        icon: Icons.logout,
                        onPressed: _logout,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
