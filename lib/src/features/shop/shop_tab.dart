```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';

class ShopTab extends StatefulWidget {
  const ShopTab({super.key});
  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  List<Map<String, Object?>> _items = [];
  int _gold = 0;

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final rows = await db.query('items');
    final session = context.read<SessionProvider>();
    final char = await db.query('characters', where: 'id = ?', whereArgs: [session.characterId]);
    setState(() {
      _items = rows;
      _gold = char.first['gold'] as int;
    });
  }

  Future<void> _buy(Map<String, Object?> item) async {
    final db = DatabaseProvider.instance.db;
    final session = context.read<SessionProvider>();
    const price = 10; // simple flat price for starter
    if (_gold < price) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough gold')));
      return;
    }
    // update gold
    final char = await db.query('characters', where: 'id = ?', whereArgs: [session.characterId]);
    final newGold = (char.first['gold'] as int) - price;
    await db.update('characters', {'gold': newGold}, where: 'id = ?', whereArgs: [session.characterId]);

    // add inventory (upsert)
    final existing = await db.query('inventory', where: 'user_id = ? AND item_id = ?', whereArgs: [session.userId, item['id']]);
    if (existing.isEmpty) {
      await db.insert('inventory', {'user_id': session.userId, 'item_id': item['id'], 'qty': 1});
    } else {
      final qty = (existing.first['qty'] as int) + 1;
      await db.update('inventory', {'qty': qty}, where: 'id = ?', whereArgs: [existing.first['id']]);
    }

    // history
    await db.insert('history', {
      'user_id': session.userId,
      'quest_id': null,
      'action': 'buy_item',
      'delta_xp': 0,
      'delta_gold': -price,
      'ts': DateTime.now().millisecondsSinceEpoch,
    });

    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bought ${item['name']} for $price gold')));
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Shop'),
              Text('Gold: $_gold'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (c, i) {
              final it = _items[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(it['name'] as String),
                  subtitle: Text('${it['rarity']} • ${it['kind']}'),
                  trailing: FilledButton(onPressed: () => _buy(it), child: const Text('Buy 10g')),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
```
