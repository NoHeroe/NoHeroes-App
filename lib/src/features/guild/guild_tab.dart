```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/db/database_provider.dart';
import '../session/session_provider.dart';

class GuildTab extends StatefulWidget {
  const GuildTab({super.key});
  @override
  State<GuildTab> createState() => _GuildTabState();
}

class _GuildTabState extends State<GuildTab> {
  List<Map<String, Object?>> _guilds = [];

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final rows = await db.query('guilds');
    setState(() => _guilds = rows);
  }

  Future<void> _createGuild() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Create Guild'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Guild name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, controller.text.trim()), child: const Text('Create')),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    final db = DatabaseProvider.instance.db;
    final id = await db.insert('guilds', {'name': name});
    final session = context.read<SessionProvider>();
    await db.insert('guild_members', {'guild_id': id, 'user_id': session.userId});
    await _load();
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
              const Text('Guilds'),
              FilledButton(onPressed: _createGuild, child: const Text('New Guild')),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _guilds.length,
            itemBuilder: (c, i) {
              final g = _guilds[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(g['name'] as String),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _GuildRoom(guildId: g['id'] as int))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GuildRoom extends StatefulWidget {
  final int guildId;
  const _GuildRoom({required this.guildId});
  @override
  State<_GuildRoom> createState() => _GuildRoomState();
}

class _GuildRoomState extends State<_GuildRoom> {
  final _msg = TextEditingController();
  List<Map<String, Object?>> _messages = [];

  Future<void> _load() async {
    final db = DatabaseProvider.instance.db;
    final rows = await db.query('messages', where: 'guild_id = ?', whereArgs: [widget.guildId], orderBy: 'ts DESC');
    setState(() => _messages = rows);
  }

  Future<void> _send() async {
    final db = DatabaseProvider.instance.db;
    final content = _msg.text.trim();
    if (content.isEmpty) return;
    await db.insert('messages', {
      'guild_id': widget.guildId,
      'user_id': 0,
      'content': content,
      'ts': DateTime.now().millisecondsSinceEpoch,
    });
    _msg.clear();
    await _load();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guild Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (c, i) {
                final m = _messages[i];
                return ListTile(
                  title: Text(m['content'] as String),
                  subtitle: Text(DateTime.fromMillisecondsSinceEpoch(m['ts'] as int).toString()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _msg, decoration: const InputDecoration(hintText: 'Message'))),
                const SizedBox(width: 8),
                IconButton(onPressed: _send, icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
```
