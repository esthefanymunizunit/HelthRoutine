import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/timer_status.dart';
import 'flower_mascot.dart';

class CircularTimer extends StatelessWidget {
  final TimerStatus status;
  final int workRemainingSeconds;
  final int breakRemainingSeconds;
  final int totalWorkSeconds;
  final String endTimeLabel;
  final bool isPomodoro;

  const CircularTimer({
    super.key,
    required this.status,
    required this.workRemainingSeconds,
    required this.breakRemainingSeconds,
    required this.totalWorkSeconds,
    required this.endTimeLabel,
    this.isPomodoro = false,
  });

  String _formatMinutesAndSeconds(int totalSeconds) {
    final minutesPart = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutesPart:$secondsPart';
  }

  double get _workProgressRatio {
    if (status == TimerStatus.setup) return 0.0;
    if (totalWorkSeconds == 0) return 0.0;
    return (totalWorkSeconds - workRemainingSeconds) / totalWorkSeconds;
  }

  @override
  Widget build(BuildContext context) {
    const double ringDiameter = 280;
    final isSetupState = status == TimerStatus.setup;
    final showPomodoroBreakContent =
        status == TimerStatus.paused && isPomodoro;

    return SizedBox(
      width: ringDiameter,
      height: ringDiameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(ringDiameter, ringDiameter),
            painter: _TimerRingPainter(
              workProgressRatio: _workProgressRatio,
              isSetupState: isSetupState,
            ),
          ),
          Container(
            margin: EdgeInsets.all(isSetupState ? 32 : 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: showPomodoroBreakContent
                  ? _PausedContent(
                      breakTimeLabel:
                          _formatMinutesAndSeconds(breakRemainingSeconds),
                    )
                  : _ActiveContent(
                      timeLabel: isSetupState
                          ? _formatMinutesAndSeconds(totalWorkSeconds)
                          : _formatMinutesAndSeconds(workRemainingSeconds),
                      endTimeLabel: endTimeLabel,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveContent extends StatelessWidget {
  final String timeLabel;
  final String endTimeLabel;

  const _ActiveContent({required this.timeLabel, required this.endTimeLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, -4),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.moodSensivel,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.white, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(timeLabel, style: AppTextStyles.displayHuge),
        const SizedBox(height: 8),
        Text(endTimeLabel, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _PausedContent extends StatelessWidget {
  final String breakTimeLabel;

  const _PausedContent({required this.breakTimeLabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FlowerMascot(size: 110),
        const SizedBox(height: 8),
        Text(
          breakTimeLabel,
          style: AppTextStyles.displayHuge.copyWith(fontSize: 32),
        ),
      ],
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double workProgressRatio;
  final bool isSetupState;

  _TimerRingPainter({
    required this.workProgressRatio,
    required this.isSetupState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ringCenter = Offset(size.width / 2, size.height / 2);
    final ringRadius = (size.width / 2) - 8;

    if (isSetupState) {
      final setupRingPaint = Paint()
        ..color = AppColors.moodSensivel
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14;
      canvas.drawCircle(ringCenter, ringRadius, setupRingPaint);
      return;
    }

    final trackPaint = Paint()
      ..color = AppColors.timerTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(ringCenter, ringRadius, trackPaint);

    final progressArcPaint = Paint()
      ..color = AppColors.moodSensivel
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    const minimumVisibleSweepRadians = 0.12;
    final sweepRadians = math.max(
      minimumVisibleSweepRadians,
      workProgressRatio * 2 * math.pi,
    );

    canvas.drawArc(
      Rect.fromCircle(center: ringCenter, radius: ringRadius),
      -math.pi / 2 - sweepRadians / 2,
      sweepRadians,
      false,
      progressArcPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) =>
      oldDelegate.workProgressRatio != workProgressRatio ||
      oldDelegate.isSetupState != isSetupState;
}
