import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../app_shell.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Entrar',
                  style: AppTheme.dark.textTheme.headlineMedium),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Entrar (mock)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
