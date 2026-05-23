import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProgressCircleSection extends StatelessWidget {
  const ProgressCircleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // O Anel desenhado customizado
          SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(painter: _DonutChartPainter()),
          ),
          // Mascote central
          const Icon(
            Icons.face_retouching_natural,
            color: AppColors.starYellow,
            size: 80,
          ),
        ],
      ),
    );
  }
}

// Pintor customizado para fazer o anel segmentado igual ao Figma
class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 16.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paintBase = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Valores fixos para visualização (25% cada pedaço com um pequeno gap)
    // O gap é gerado porque o sweepAngle não é 100% de pi/2
    final sweepAngle = (pi / 2) * 0.85;

    // Verde (Topo Direita)
    canvas.drawArc(
      rect,
      -pi / 2 + 0.1,
      sweepAngle,
      false,
      paintBase..color = const Color(0xFF1B8743),
    );
    // Azul (Baixo Direita)
    canvas.drawArc(
      rect,
      0.1,
      sweepAngle,
      false,
      paintBase..color = AppColors.blueVariant,
    );
    // Rosa (Baixo Esquerda)
    canvas.drawArc(
      rect,
      pi / 2 + 0.1,
      sweepAngle,
      false,
      paintBase..color = AppColors.moodAnimada,
    );
    // Laranja/Amarelo (Topo Esquerda)
    canvas.drawArc(
      rect,
      pi + 0.1,
      sweepAngle,
      false,
      paintBase..color = AppColors.moodInsegura,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
