import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TimerHeader extends StatelessWidget {
  final VoidCallback onClose;

  const TimerHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.timerTitle, style: AppTextStyles.heading2),
        Material(
          color: AppColors.closeButtonBg,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onClose,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.close, color: AppColors.black, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}
