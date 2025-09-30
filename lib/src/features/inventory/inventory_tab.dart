```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});
  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  List<Map<String, Object?>> _rows = [];

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final session = context.read<SessionProvider>();
    final rows = await db.rawQuery('''
      SELECT inventory.id, items.name, items.rarity, items.kind, items.effect, inventory.qty
      FROM inventory
      JOIN items ON items.id = inventory.item_id
      WHERE inventory.user_id = ?
    ''', [session.userId]);
    setState(() => _rows = rows);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _rows.length,
        itemBuilder: (c, i) {
          final it = _rows[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(it['name'] as String),
              subtitle: Text('${it['rarity']} • ${it['kind']}\n${it['effect']}'),
              isThreeLine: true,
              trailing: Text('x${it['qty']}'),
            ),
          );
        },
      ),
    );
  }
}
```
