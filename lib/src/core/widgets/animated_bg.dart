import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBg extends StatefulWidget {
  const AnimatedBg({super.key});

  @override
  State<AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value * 2 * math.pi;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.4 * math.cos(t), 0.4 * math.sin(t)),
              radius: 1.2,
              colors: const [
                Color(0xFF0F0F17),
                Color(0xFF0B0B10),
              ],
            ),
          ),
        );
      },
    );
  }
}
