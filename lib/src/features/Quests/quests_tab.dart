```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';

class QuestsTab extends StatefulWidget {
  const QuestsTab({super.key});
  @override
  State<QuestsTab> createState() => _QuestsTabState();
}

class _QuestsTabState extends State<QuestsTab> {
  List<Map<String, Object?>> _quests = [];

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final rows = await db.query('quests');
    setState(() => _quests = rows);
  }

  Future<void> _complete(Map<String, Object?> quest) async {
    final db = DatabaseProvider.instance.db;
    final session = context.read<SessionProvider>();
    final rewardXp = quest['reward_xp'] as int;
    final rewardGold = quest['reward_gold'] as int;

    // update character
    final char = await db.query('characters', where: 'id = ?', whereArgs: [session.characterId]);
    var xp = (char.first['xp'] as int) + rewardXp;
    var level = char.first['level'] as int;
    while (xp >= 100) { // simple level-up rule
      xp -= 100;
      level += 1;
    }
    final gold = (char.first['gold'] as int) + rewardGold;
    await db.update('characters', {'xp': xp, 'level': level, 'gold': gold}, where: 'id = ?', whereArgs: [session.characterId]);

    // add to history
    await db.insert('history', {
      'user_id': session.userId,
      'quest_id': quest['id'],
      'action': 'complete_quest',
      'delta_xp': rewardXp,
      'delta_gold': rewardGold,
      'ts': DateTime.now().millisecondsSinceEpoch,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Completed: ${quest['title']}  +$rewardXp XP  +$rewardGold gold')));
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
        itemCount: _quests.length,
        itemBuilder: (c, i) {
          final q = _quests[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(q['title'] as String),
              subtitle: Text((q['description'] as String?) ?? ''),
              trailing: FilledButton(
                onPressed: () => _complete(q),
                child: const Text('Complete'),
              ),
            ),
          );
        },
      ),
    );
  }
}
```
