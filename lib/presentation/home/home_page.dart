import 'package:flutter/material.dart';
import '../app_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('Home Base do NoHeroes App'),
        ),
      ),
    );
  }
}
