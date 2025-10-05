import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Fundo animado estilo "brasas" do site NoHeroes
class AnimatedBg extends StatefulWidget {
  const AnimatedBg({super.key});

  @override
  State<AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    // cria 150 partículas iniciais
    for (int i = 0; i < 150; i++) {
      _particles.add(_Particle.random(startAnywhere: true));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateParticles)
     ..repeat();
  }

  void _updateParticles() {
    for (final p in _particles) {
      p.update(MediaQuery.of(context).size);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BrasasPainter(_particles),
      child: Container(color: const Color(0xFF0A0A0A)), // fundo escuro
    );
  }
}

/// Partícula individual
class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double alpha;
  double drift;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.alpha,
    required this.drift,
  });

  factory _Particle.random({bool startAnywhere = false}) {
    final rand = math.Random();
    return _Particle(
      x: rand.nextDouble(),
      y: startAnywhere ? rand.nextDouble() : 1.2,
      size: 1 + rand.nextDouble() * 2.5,
      speed: 0.0002 + rand.nextDouble() * 0.0005,
      alpha: 0.4 + rand.nextDouble() * 0.3,
      drift: (rand.nextDouble() - 0.5) * 0.002,
    );
  }

  void update(Size screen) {
    y -= speed * 60;
    x += drift * 60;
    if (y < -0.02 || x < -0.05 || x > 1.05) {
      // reset na parte de baixo
      x = math.Random().nextDouble();
      y = 1.1;
    }
  }

  Offset getOffset(Size screen) => Offset(x * screen.width, y * screen.height);
}

class _BrasasPainter extends CustomPainter {
  final List<_Particle> particles;
  _BrasasPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA855F7).withOpacity(0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    for (final p in particles) {
      final offset = p.getOffset(size);
      canvas.drawCircle(offset, p.size, paint..color = paint.color.withOpacity(p.alpha));
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
