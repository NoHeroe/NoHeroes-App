```dart
import 'package:flutter/material.dart';
import '../../core/db/database_provider.dart';
import '../character/create_character_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _loading = false;

  Future<void> _signup() async {
    setState(() => _loading = true);
    final db = DatabaseProvider.instance.db;
    try {
      final id = await db.insert('users', {
        'email': _email.text.trim(),
        'password': _password.text.trim(),
        'display_name': _name.text.trim(),
      });
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CreateCharacterScreen(userId: id)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email already registered')));
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Display name')),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loading ? null : _signup, child: _loading ? const CircularProgressIndicator() : const Text('Create account')),
          ],
        ),
      ),
    );
  }
}
```
