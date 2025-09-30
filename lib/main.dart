```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'src/core/db/database_provider.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/auth_gate.dart';
import 'src/features/session/session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.init();
  runApp(const NoHeroesApp());
}

class NoHeroesApp extends StatelessWidget {
  const NoHeroesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NoHeroes',
        theme: AppTheme.dark,
        home: const AuthGate(),
      ),
    );
  }
}
```
