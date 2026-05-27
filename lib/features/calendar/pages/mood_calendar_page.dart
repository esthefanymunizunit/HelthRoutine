import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MoodCalendarPage extends StatelessWidget {
  const MoodCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _HighlightedTitle(
                          leading: 'Mood',
                          highlighted: 'Calendar',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ma 26',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const _WeekdayRow(),
              const SizedBox(height: 10),

              const _MoodCalendarGrid(),
              const SizedBox(height: 18),

              const _MonthMoodCard(),
              const SizedBox(height: 24),

              const _StatsRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedTitle extends StatelessWidget {
  final String leading;
  final String highlighted;

  const _HighlightedTitle({required this.leading, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = AppTextStyles.heading1.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: leading + ' '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.starYellow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(highlighted, style: baseStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  static const List<String> _labels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MoodCalendarGrid extends StatelessWidget {
  const _MoodCalendarGrid();

  static const List<_MoodType?> _moods = [
    null,
    null,
    _MoodType.calm,
    _MoodType.calm,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.angry,
    null,
    _MoodType.anxious,
    _MoodType.alert,
    _MoodType.angry,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.happy,
    null,
    null,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.happy,
    _MoodType.angry,
    _MoodType.happy,
    _MoodType.happy,
    _MoodType.calm,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.angry,
    null,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final mood = _moods[index];
        return _MoodDayCell(mood: mood);
      },
    );
  }
}

class _MoodDayCell extends StatelessWidget {
  final _MoodType? mood;

  const _MoodDayCell({required this.mood});

  @override
  Widget build(BuildContext context) {
    final Color fillColor = _MoodPalette.colorFor(mood);

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: mood == null
          ? null
          : CustomPaint(
              painter: _MoodFacePainter(type: mood!),
              child: const SizedBox.expand(),
            ),
    );
  }
}

enum _MoodType { happy, calm, angry, anxious, alert }

class _MoodPalette {
  static Color colorFor(_MoodType? mood) {
    switch (mood) {
      case _MoodType.happy:
        return AppColors.moodAnimada;
      case _MoodType.calm:
        return AppColors.moodSensivel;
      case _MoodType.angry:
        return AppColors.moodBrava;
      case _MoodType.anxious:
        return AppColors.moodInsegura;
      case _MoodType.alert:
        return AppColors.alertRed;
      default:
        return const Color(0xFFF1F1F1);
    }
  }
}

class _MoodFacePainter extends CustomPainter {
  final _MoodType type;

  _MoodFacePainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    switch (type) {
      case _MoodType.happy:
        _drawClosedEyes(canvas, size, paint, mouthSmile: true);
        break;
      case _MoodType.calm:
        _drawClosedEyes(
          canvas,
          size,
          paint,
          mouthSmile: true,
          mouthSmall: true,
        );
        break;
      case _MoodType.angry:
        _drawAngryFace(canvas, size, paint);
        break;
      case _MoodType.anxious:
        _drawAnxiousFace(canvas, size, paint);
        break;
      case _MoodType.alert:
        _drawAlertFace(canvas, size, paint);
        break;
    }
  }

  void _drawClosedEyes(
    Canvas canvas,
    Size size,
    Paint paint, {
    required bool mouthSmile,
    bool mouthSmall = false,
  }) {
    final double eyeY = size.height * 0.42;
    final double eyeWidth = size.width * 0.18;
    final double eyeSpacing = size.width * 0.22;
    final Offset leftStart = Offset(size.width * 0.25, eyeY);
    final Offset rightStart = Offset(size.width * 0.25 + eyeSpacing, eyeY);

    canvas.drawLine(leftStart, leftStart.translate(eyeWidth, 0), paint);
    canvas.drawLine(rightStart, rightStart.translate(eyeWidth, 0), paint);

    final Rect mouthRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.66),
      width: size.width * (mouthSmall ? 0.28 : 0.4),
      height: size.height * (mouthSmall ? 0.16 : 0.25),
    );
    canvas.drawArc(
      mouthRect,
      mouthSmile ? 0.1 : 3.2,
      mouthSmile ? 3.0 : 3.0,
      false,
      paint,
    );
  }

  void _drawAngryFace(Canvas canvas, Size size, Paint paint) {
    final double eyeY = size.height * 0.35;
    canvas.drawLine(
      Offset(size.width * 0.25, eyeY),
      Offset(size.width * 0.4, eyeY + 4),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, eyeY + 4),
      Offset(size.width * 0.75, eyeY),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.45),
      Offset(size.width * 0.4, size.height * 0.45),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.45),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.68),
      Offset(size.width * 0.65, size.height * 0.68),
      paint,
    );
  }

  void _drawAnxiousFace(Canvas canvas, Size size, Paint paint) {
    final Paint fillBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final Paint fillWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Offset leftEyeCenter = Offset(size.width * 0.36, size.height * 0.5);
    canvas.drawCircle(leftEyeCenter, size.width * 0.16, fillWhite);
    canvas.drawCircle(leftEyeCenter, size.width * 0.07, fillBlack);

    canvas.drawCircle(
      Offset(size.width * 0.66, size.height * 0.5),
      size.width * 0.05,
      fillBlack,
    );
  }

  void _drawAlertFace(Canvas canvas, Size size, Paint paint) {
    final Paint triangleFill = Paint()
      ..color = AppColors.softYellow
      ..style = PaintingStyle.fill;
    final Paint triangleStroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path triangle = Path()
      ..moveTo(size.width * 0.5, size.height * 0.25)
      ..lineTo(size.width * 0.2, size.height * 0.75)
      ..lineTo(size.width * 0.8, size.height * 0.75)
      ..close();

    canvas.drawPath(triangle, triangleFill);
    canvas.drawPath(triangle, triangleStroke);

    final Paint exclamation = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.52),
        width: size.width * 0.05,
        height: size.height * 0.18,
      ),
      exclamation,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.68),
      size.width * 0.03,
      exclamation,
    );
  }

  @override
  bool shouldRepaint(covariant _MoodFacePainter oldDelegate) {
    return oldDelegate.type != type;
  }
}

class _MonthMoodCard extends StatelessWidget {
  const _MonthMoodCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.moodAnimada,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood do mes',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Animada',
                  style: AppTextStyles.heading1.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  'voce esta calma e otimista. Continue\ncom essa energia boa!',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(painter: _LargeSmilePainter()),
          ),
        ],
      ),
    );
  }
}

class _LargeSmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.45),
        width: size.width * 0.35,
        height: size.height * 0.25,
      ),
      0.2,
      2.6,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.45),
        width: size.width * 0.35,
        height: size.height * 0.25,
      ),
      0.2,
      2.6,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.7),
        width: size.width * 0.7,
        height: size.height * 0.45,
      ),
      0.1,
      3.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LargeSmilePainter oldDelegate) => false;
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatItem(
          title: 'Atividade Fisica',
          value: '101,65',
          subtitle: 'Passos',
        ),
        _StatItem(title: 'Meditacao', value: '25/30', subtitle: 'Sessoes'),
        _StatItem(title: 'Disciplina', value: '89%', subtitle: 'Foco'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatItem({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
