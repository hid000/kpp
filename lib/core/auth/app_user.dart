/// Дані поточного користувача, які зберігає Firebase Authentication.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// Ім'я для відображення; якщо його не задано — частина email до «@».
  String get name {
    final String? value = displayName?.trim();
    if (value != null && value.isNotEmpty) return value;
    return email.split('@').first;
  }

  /// Перше слово імені (для привітання).
  String get firstName => name.split(RegExp(r'\s+')).first;

  /// Прізвище (все після першого слова) або порожній рядок.
  String get lastName {
    final List<String> parts = name.split(RegExp(r'\s+'));
    return parts.length > 1 ? parts.skip(1).join(' ') : '';
  }
}
