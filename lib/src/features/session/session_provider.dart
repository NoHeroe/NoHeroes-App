```dart
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  int? userId;
  int? characterId;
  String? displayName;

  bool get isLoggedIn => userId != null;

  void setSession({required int user, required int character, required String name}) {
    userId = user;
    characterId = character;
    displayName = name;
    notifyListeners();
  }

  void logout() {
    userId = null;
    characterId = null;
    displayName = null;
    notifyListeners();
  }
}
```
