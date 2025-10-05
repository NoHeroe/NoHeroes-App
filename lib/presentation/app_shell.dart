import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/widgets/animated_bg.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: AnimatedBg()),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withOpacity(0.15)),
          ),
        ),
        child,
      ],
    );
  }
}
