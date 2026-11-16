import 'package:firebase_auth/firebase_auth.dart';

import 'app_user.dart';
import 'auth_failure.dart';

/// Єдина точка взаємодії застосунку з автентифікацією.
/// Екрани працюють лише з цим інтерфейсом і нічого не знають про Firebase.
abstract interface class AuthRepository {
  /// Поточний користувач або `null`, якщо вхід не виконано.
  AppUser? get currentUser;

  /// Поточний користувач одразу після підписки, далі — при кожній зміні
  /// (вхід, вихід, оновлення профілю). Перша подія надходить після
  /// відновлення збереженого сеансу.
  Stream<AppUser?> userChanges();

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});

  /// Оновлює ім'я та/або URL фото. Порожній [photoUrl] прибирає фото.
  Future<void> updateProfile({String? displayName, String? photoUrl});

  /// Змінює пароль: спершу повторно підтверджує особу поточним паролем.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

/// Реалізація на Firebase Authentication (email/пароль).
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  /// Виконує операцію Firebase і перетворює [FirebaseAuthException]
  /// на [AuthFailure] з повідомленням для користувача.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromCode(e.code);
    }
  }

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Stream<AppUser?> userChanges() => _auth.userChanges().map(_toAppUser);

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) => _guard(() async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email.trim(), password: password);
    await credential.user?.updateDisplayName(displayName.trim());
    await credential.user?.reload();
  });

  @override
  Future<void> signIn({required String email, required String password}) =>
      _guard(
        () => _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        ),
      );

  @override
  Future<void> signOut() => _guard(_auth.signOut);

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) =>
      _guard(() async {
        final User? user = _auth.currentUser;
        if (user == null) throw AuthFailure.fromCode('requires-recent-login');
        if (displayName != null) await user.updateDisplayName(displayName);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl.isEmpty ? null : photoUrl);
        }
        await user.reload();
      });

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final User? user = _auth.currentUser;
    final String? email = user?.email;
    if (user == null || email == null) {
      throw AuthFailure.fromCode('requires-recent-login');
    }
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: currentPassword),
      );
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      // Помилка повторного підтвердження означає неправильний поточний пароль.
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw const AuthFailure(
          'wrong-password',
          'Поточний пароль введено неправильно.',
        );
      }
      throw AuthFailure.fromCode(e.code);
    }
  }
}
