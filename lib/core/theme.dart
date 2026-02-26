import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'constants.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFBFC3C8),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 46,
          height: 1,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.gradientBottom),
    );
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

class MaizuCard extends StatelessWidget {
  const MaizuCard({required this.child, super.key, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [AppColors.gradientTop, AppColors.gradientBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x42000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(painter: _HoneycombPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _HoneycombPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
      ..color = Colors.white;
    const radius = 17.0;
    const spacingX = radius * 1.7;
    const spacingY = radius * 1.5;

    for (double y = -radius; y < size.height + radius; y += spacingY) {
      for (double x = -radius; x < size.width + radius; x += spacingX) {
        final dx = ((y / spacingY).floor().isEven) ? x : x + spacingX / 2;
        _drawHex(canvas, Offset(dx, y), radius, paint);
      }
    }
  }

  void _drawHex(Canvas canvas, Offset center, double r, Paint p) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * math.pi / 180;
      final point = Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
