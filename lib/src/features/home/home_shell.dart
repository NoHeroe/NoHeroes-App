```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../session/session_provider.dart';
import '../quests/quests_tab.dart';
import '../inventory/inventory_tab.dart';
import '../shop/shop_tab.dart';
import '../guild/guild_tab.dart';
import '../chat/chat_tab.dart';
import '../history/history_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _tabs = const [
    QuestsTab(), InventoryTab(), ShopTab(), GuildTab(), ChatTab()
  ];

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('NoHeroes — ${session.displayName ?? 'Player'}')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('NoHeroes')),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
            )
          ],
        ),
      ),
      body: _tabs[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Guild'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
```
