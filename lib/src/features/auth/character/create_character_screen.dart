```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';
import '../home/home_shell.dart';

class CreateCharacterScreen extends StatefulWidget {
  final int userId;
  const CreateCharacterScreen({super.key, required this.userId});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final _name = TextEditingController();

  Future<void> _create() async {
    final db = DatabaseProvider.instance.db;
    final id = await db.insert('characters', {
      'user_id': widget.userId,
      'name': _name.text.trim().isEmpty ? 'Rookie' : _name.text.trim(),
      'avatar': '',
      'level': 1,
      'xp': 0,
      'gold': 0,
    });
    context.read<SessionProvider>().setSession(user: widget.userId, character: id, name: _name.text.trim().isEmpty ? 'Rookie' : _name.text.trim());
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Character')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Name your character'),
            const SizedBox(height: 8),
            TextField(controller: _name, decoration: const InputDecoration(hintText: 'e.g., Akira')), 
            const SizedBox(height: 16),
            FilledButton(onPressed: _create, child: const Text('Start Adventure'))
          ],
        ),
      ),
    );
  }
}
```
