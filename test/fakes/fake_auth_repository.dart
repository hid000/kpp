import 'dart:async';

import 'package:kpp/core/auth/app_user.dart';
import 'package:kpp/core/auth/auth_failure.dart';
import 'package:kpp/core/auth/auth_repository.dart';

/// Підробка [AuthRepository] у пам'яті для тестів: має один готовий
/// обліковий запис і дозволяє імітувати затримку та помилки Firebase.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    bool signedIn = false,
    this.delay = Duration.zero,
    this.failWith,
  }) {
    if (signedIn) _user = _toUser(_accounts[seedEmail]!);
  }

  static const String seedEmail = 'roman.dub@lpnu.ua';
  static const String seedPassword = 'password1';

  /// Затримка кожної операції (для перевірки стану завантаження).
  final Duration delay;

  /// Код помилки Firebase, яку кинуть усі операції (крім `signOut`).
  String? failWith;

  final Map<String, _Account> _accounts = {
    seedEmail: _Account(
      uid: 'uid-1',
      email: seedEmail,
      password: seedPassword,
      displayName: 'Роман Дуб',
    ),
  };
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  AppUser? _user;

  final List<String> resetEmails = [];

  static AppUser _toUser(_Account a) => AppUser(
    uid: a.uid,
    email: a.email,
    displayName: a.displayName,
    photoUrl: a.photoUrl,
  );

  void _emit(AppUser? user) {
    _user = user;
    _controller.add(user);
  }

  Future<void> _step() async {
    if (delay > Duration.zero) await Future<void>.delayed(delay);
    if (failWith != null) throw AuthFailure.fromCode(failWith!);
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> userChanges() async* {
    yield _user;
    yield* _controller.stream;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _step();
    if (_accounts.containsKey(email.trim())) {
      throw AuthFailure.fromCode('email-already-in-use');
    }
    final _Account account = _Account(
      uid: 'uid-${_accounts.length + 1}',
      email: email.trim(),
      password: password,
      displayName: displayName,
    );
    _accounts[account.email] = account;
    _emit(_toUser(account));
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _step();
    final _Account? account = _accounts[email.trim()];
    if (account == null || account.password != password) {
      throw AuthFailure.fromCode('invalid-credential');
    }
    _emit(_toUser(account));
  }

  @override
  Future<void> signOut() async => _emit(null);

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _step();
    resetEmails.add(email.trim());
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    await _step();
    final _Account account = _accounts[_user!.email]!;
    if (displayName != null) account.displayName = displayName;
    if (photoUrl != null) {
      account.photoUrl = photoUrl.isEmpty ? null : photoUrl;
    }
    _emit(_toUser(account));
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _step();
    final _Account account = _accounts[_user!.email]!;
    if (account.password != currentPassword) {
      throw const AuthFailure(
        'wrong-password',
        'Поточний пароль введено неправильно.',
      );
    }
    account.password = newPassword;
  }

  /// Пароль акаунта (для перевірки змін у тестах).
  String passwordOf(String email) => _accounts[email]!.password;
}

class _Account {
  _Account({
    required this.uid,
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String uid;
  final String email;
  String password;
  String displayName;
  String? photoUrl;
}
