import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../models/timer_status.dart';
import '../widgets/action_buttons.dart';
import '../widgets/break_duration_selector.dart';
import '../widgets/circular_timer.dart';
import '../widgets/success_modal.dart';
import '../widgets/timer_header.dart';

class TimerPage extends StatefulWidget {
  final String? taskTitle;
  final int? workDurationMinutes;
  final bool isPomodoro;

  const TimerPage({
    super.key,
    this.taskTitle,
    this.workDurationMinutes,
    this.isPomodoro = false,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const int _defaultWorkDurationMinutes = 60;
  static const int _minBreakDurationMinutes = 5;
  static const int _maxBreakDurationMinutes = 30;
  static const int _finishedModalAutoDismissMilliseconds = 2500;

  TimerStatus _currentStatus = TimerStatus.setup;
  late int _workDurationInSeconds;
  late int _workRemainingSeconds;
  late int _breakDurationMinutes;
  int _breakRemainingSeconds = 0;
  Timer? _countdownTicker;

  @override
  void initState() {
    super.initState();
    final resolvedWorkMinutes =
        widget.workDurationMinutes ?? _defaultWorkDurationMinutes;
    _workDurationInSeconds = resolvedWorkMinutes * 60;
    _workRemainingSeconds = _workDurationInSeconds;
    _breakDurationMinutes = (resolvedWorkMinutes / 5).round().clamp(
          _minBreakDurationMinutes,
          _maxBreakDurationMinutes,
        );
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    super.dispose();
  }

  void _startWorkSession() {
    setState(() {
      _currentStatus = TimerStatus.running;
      _workRemainingSeconds = _workDurationInSeconds;
    });
    _startCountdownTicker();
  }

  void _pauseIntoBreak() {
    setState(() {
      _currentStatus = TimerStatus.paused;
      if (widget.isPomodoro) {
        _breakRemainingSeconds = _breakDurationMinutes * 60;
      } else {
        _breakRemainingSeconds = 0;
      }
    });
  }

  void _resumeWorkSession() {
    setState(() => _currentStatus = TimerStatus.running);
  }

  void _finishSession() {
    _countdownTicker?.cancel();
    setState(() => _currentStatus = TimerStatus.finished);
    Future.delayed(
      const Duration(milliseconds: _finishedModalAutoDismissMilliseconds),
      () {
        if (!mounted) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        } else {
          _resetToSetup();
        }
      },
    );
  }

  void _resetToSetup() {
    _countdownTicker?.cancel();
    setState(() {
      _currentStatus = TimerStatus.setup;
      _workRemainingSeconds = _workDurationInSeconds;
      _breakRemainingSeconds = 0;
    });
  }

  void _closeTimerPage() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _adjustBreakDurationByMinutes(int deltaMinutes) {
    setState(
      () => _breakDurationMinutes = (_breakDurationMinutes + deltaMinutes)
          .clamp(_minBreakDurationMinutes, _maxBreakDurationMinutes),
    );
  }

  void _startCountdownTicker() {
    _countdownTicker?.cancel();
    _countdownTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_currentStatus == TimerStatus.running) {
          if (_workRemainingSeconds > 0) {
            _workRemainingSeconds--;
          } else {
            _finishSession();
          }
        } else if (_currentStatus == TimerStatus.paused && widget.isPomodoro) {
          if (_breakRemainingSeconds > 0) {
            _breakRemainingSeconds--;
          } else {
            _resumeWorkSession();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowBottomNav = _currentStatus == TimerStatus.setup;

    return Scaffold(
      backgroundColor: AppColors.timerBackground,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  TimerHeader(onClose: _closeTimerPage),
                  const SizedBox(height: 24),
                  Text(
                    widget.taskTitle ?? AppStrings.timerDemoTaskTitle,
                    style: AppTextStyles.heading1,
                  ),
                  if (widget.isPomodoro) ...[
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.timerMethodPomodoro,
                      style: AppTextStyles.heading1,
                    ),
                  ],
                  const SizedBox(height: 32),
                  Expanded(
                    child: Center(
                      child: CircularTimer(
                        status: _currentStatus,
                        workRemainingSeconds: _workRemainingSeconds,
                        breakRemainingSeconds: _breakRemainingSeconds,
                        totalWorkSeconds: _workDurationInSeconds,
                        endTimeLabel: AppStrings.timerDemoEndTime,
                        isPomodoro: widget.isPomodoro,
                      ),
                    ),
                  ),
                  _buildStatusLabelForCurrentState(),
                  const SizedBox(height: 16),
                  _buildActionButtonsForCurrentState(),
                  SizedBox(height: shouldShowBottomNav ? 56 : 24),
                ],
              ),
            ),
          ),
          if (_currentStatus == TimerStatus.finished) const SuccessModal(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          shouldShowBottomNav ? CustomBottomNav.buildFAB(context) : null,
      bottomNavigationBar: shouldShowBottomNav
          ? CustomBottomNav(currentIndex: 0, onTap: (_) {})
          : null,
    );
  }

  Widget _buildStatusLabelForCurrentState() {
    switch (_currentStatus) {
      case TimerStatus.running:
      case TimerStatus.finished:
        if (!widget.isPomodoro) return const SizedBox.shrink();
        return BreakDurationSelector(
          minutes: _breakDurationMinutes,
          onMinus: () => _adjustBreakDurationByMinutes(-1),
          onPlus: () => _adjustBreakDurationByMinutes(1),
        );
      case TimerStatus.paused:
        if (!widget.isPomodoro) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            AppStrings.timerPauseActive,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.cloudBlue,
              fontSize: 18,
            ),
          ),
        );
      case TimerStatus.setup:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtonsForCurrentState() {
    switch (_currentStatus) {
      case TimerStatus.setup:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: PrimaryActionButton(
            label: AppStrings.timerStartSession,
            onPressed: _startWorkSession,
          ),
        );
      case TimerStatus.running:
      case TimerStatus.finished:
        return DualActionButton(
          primaryLabel: AppStrings.timerPause,
          primaryIcon: Icons.pause,
          onPrimary: _pauseIntoBreak,
          secondaryLabel: AppStrings.timerFinish,
          onSecondary: _finishSession,
        );
      case TimerStatus.paused:
        return DualActionButton(
          primaryLabel: AppStrings.timerResume,
          primaryIcon: Icons.play_arrow,
          onPrimary: _resumeWorkSession,
          secondaryLabel: AppStrings.timerFinish,
          onSecondary: _finishSession,
        );
    }
  }
}
