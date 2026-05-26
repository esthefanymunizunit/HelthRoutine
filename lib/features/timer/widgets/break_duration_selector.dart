import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class BreakDurationSelector extends StatelessWidget {
  final int minutes;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const BreakDurationSelector({
    super.key,
    required this.minutes,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onMinus,
          icon: const Icon(Icons.remove, color: AppColors.black, size: 26),
        ),
        const SizedBox(width: 12),
        Text(
          AppStrings.timerBreakLabel(minutes),
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.cloudBlue,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onPlus,
          icon: const Icon(Icons.add, color: AppColors.black, size: 26),
        ),
      ],
    );
  }
}
