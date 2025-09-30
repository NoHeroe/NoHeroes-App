```dart
import 'package:flutter/material.dart';
import '../../core/db/database_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, Object?>> _rows = [];

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final rows = await db.rawQuery('''
      SELECT h.*, q.title as quest_title FROM history h
      LEFT JOIN quests q ON q.id = h.quest_id
      ORDER BY ts DESC
    ''');
    setState(() => _rows = rows);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: _rows.length,
        itemBuilder: (c, i) {
          final r = _rows[i];
          return ListTile(
            leading: Icon(r['action'] == 'complete_quest' ? Icons.check_circle : Icons.shopping_cart),
            title: Text(r['action'] as String),
            subtitle: Text((r['quest_title'] as String?) ?? ''),
            trailing: Text(DateTime.fromMillisecondsSinceEpoch(r['ts'] as int).toString()),
          );
        },
      ),
    );
  }
}
```
