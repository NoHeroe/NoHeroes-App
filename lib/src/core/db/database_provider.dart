```dart
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider instance = DatabaseProvider._();
  Database? _db;
  Database get db => _db!;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'noheroes.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Users
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            display_name TEXT
          );
        ''');
        // Character
        await db.execute('''
          CREATE TABLE characters(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            avatar TEXT,
            level INTEGER NOT NULL DEFAULT 1,
            xp INTEGER NOT NULL DEFAULT 0,
            gold INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY(user_id) REFERENCES users(id)
          );
        ''');
        // Quests
        await db.execute('''
          CREATE TABLE quests(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            qtype TEXT NOT NULL, -- daily | side | individual
            reward_xp INTEGER NOT NULL,
            reward_gold INTEGER NOT NULL
          );
        ''');
        // Inventory items
        await db.execute('''
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            rarity TEXT,
            kind TEXT,
            effect TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE inventory(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            item_id INTEGER NOT NULL,
            qty INTEGER NOT NULL DEFAULT 1,
            FOREIGN KEY(user_id) REFERENCES users(id),
            FOREIGN KEY(item_id) REFERENCES items(id)
          );
        ''');
        // History
        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            quest_id INTEGER,
            action TEXT NOT NULL, -- complete_quest | buy_item | use_item
            delta_xp INTEGER DEFAULT 0,
            delta_gold INTEGER DEFAULT 0,
            ts INTEGER NOT NULL,
            FOREIGN KEY(user_id) REFERENCES users(id),
            FOREIGN KEY(quest_id) REFERENCES quests(id)
          );
        ''');
        // Guilds & chat (local only for now)
        await db.execute('''
          CREATE TABLE guilds(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          );
        ''');
        await db.execute('''
          CREATE TABLE guild_members(
            guild_id INTEGER,
            user_id INTEGER,
            PRIMARY KEY(guild_id, user_id)
          );
        ''');
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            guild_id INTEGER,
            user_id INTEGER,
            content TEXT NOT NULL,
            ts INTEGER NOT NULL
          );
        ''');

        // Seed starter quests & items
        await db.insert('quests', {
          'title': 'Train for 30 minutes',
          'description': 'Workout or run',
          'qtype': 'daily',
          'reward_xp': 20,
          'reward_gold': 5,
        });
        await db.insert('quests', {
          'title': 'Study for 1 hour',
          'description': 'Focus on a new topic',
          'qtype': 'daily',
          'reward_xp': 25,
          'reward_gold': 7,
        });
        await db.insert('items', {
          'name': 'Small Health Potion',
          'rarity': 'common',
          'kind': 'consumable',
          'effect': '+10 HP (flavor)'
        });
        await db.insert('items', {
          'name': 'Bronze Sword',
          'rarity': 'uncommon',
          'kind': 'weapon',
          'effect': '+1 ATK (flavor)'
        });
      },
    );
  }
}
```
