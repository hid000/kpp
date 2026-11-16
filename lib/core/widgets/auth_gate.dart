import 'package:flutter/material.dart';

import '../auth/app_user.dart';
import '../services/app_services.dart';

/// Обирає, що показати залежно від стану автентифікації.
///
/// Firebase відновлює збережений сеанс асинхронно, тому до першої події
/// [AuthRepository.userChanges] показується індикатор завантаження.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key, required this.signedIn, required this.signedOut});

  final Widget signedIn;
  final Widget signedOut;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<AppUser?>? _restored;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _restored ??= AppServices.of(context).auth.userChanges().first;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser?>(
      future: _restored,
      initialData: AppServices.of(context).auth.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done &&
            snapshot.data == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snapshot.data == null ? widget.signedOut : widget.signedIn;
      },
    );
  }
}
