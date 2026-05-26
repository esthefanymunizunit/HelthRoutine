import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FlowerMascot extends StatelessWidget {
  final double size;

  const FlowerMascot({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FlowerPainter()),
    );
  }
}

class _FlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final flowerCenter = Offset(size.width / 2, size.height / 2);
    final petalRadius = size.width * 0.26;
    final petalDistanceFromCenter = size.width * 0.24;

    final petalPaint = Paint()..color = AppColors.starYellow;

    for (int petalIndex = 0; petalIndex < 5; petalIndex++) {
      final petalAngle =
          -math.pi / 2 + (petalIndex * 2 * math.pi / 5);
      final petalCenter = Offset(
        flowerCenter.dx + petalDistanceFromCenter * math.cos(petalAngle),
        flowerCenter.dy + petalDistanceFromCenter * math.sin(petalAngle),
      );
      canvas.drawCircle(petalCenter, petalRadius, petalPaint);
    }

    canvas.drawCircle(flowerCenter, petalRadius * 1.05, petalPaint);

    final cheekPaint = Paint()..color = AppColors.moodAnimada;
    final cheekRadius = size.width * 0.05;
    canvas.drawCircle(
      Offset(
        flowerCenter.dx - size.width * 0.13,
        flowerCenter.dy + size.height * 0.04,
      ),
      cheekRadius,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(
        flowerCenter.dx + size.width * 0.13,
        flowerCenter.dy + size.height * 0.04,
      ),
      cheekRadius,
      cheekPaint,
    );

    final faceStrokePaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          flowerCenter.dx - size.width * 0.10,
          flowerCenter.dy - size.height * 0.04,
        ),
        width: size.width * 0.10,
        height: size.height * 0.07,
      ),
      0,
      math.pi,
      false,
      faceStrokePaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          flowerCenter.dx + size.width * 0.10,
          flowerCenter.dy - size.height * 0.04,
        ),
        width: size.width * 0.10,
        height: size.height * 0.07,
      ),
      0,
      math.pi,
      false,
      faceStrokePaint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          flowerCenter.dx,
          flowerCenter.dy + size.height * 0.09,
        ),
        width: size.width * 0.14,
        height: size.height * 0.08,
      ),
      0,
      math.pi,
      false,
      faceStrokePaint,
    );
  }

  @override
  bool shouldRepaint(_FlowerPainter oldDelegate) => false;
}
