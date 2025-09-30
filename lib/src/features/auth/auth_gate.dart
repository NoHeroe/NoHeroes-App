```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';
import 'login_screen.dart';
import '../character/create_character_screen.dart';
import '../home/home_shell.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // If there's a user logged (future: via shared_prefs), jump. For now, show Login.
  }

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
```
