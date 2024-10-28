import 'dart:math';

import 'package:flutter/material.dart';

class AvatarPainter extends CustomPainter {
  final String name;
  final List<Color> colors;

  AvatarPainter(this.name) : colors = _generateColorsFromName(name);

  static List<Color> _generateColorsFromName(String input) {
    // Generate 3 consistent colors from the name's hash.
    final seed = input.hashCode;
    final random = Random(seed);
    return List.generate(
        3, (_) => Color(0xFF000000 + random.nextInt(0xFFFFFF)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final double width = size.width / 3;

    // Draw three vertical bars with generated colors.
    for (int i = 0; i < 3; i++) {
      paint.color = colors[i];
      canvas.drawRect(
        Rect.fromLTWH(i * width, 0, width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BoringAvatar extends StatelessWidget {
  final String name;
  final double size;

  const BoringAvatar({required this.name, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CustomPaint(
        size: Size(size, size),
        painter: AvatarPainter(name),
      ),
    );
  }
}
