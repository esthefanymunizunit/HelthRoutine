import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SuccessModal extends StatelessWidget {
  const SuccessModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.successGreenLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.templateGreenDark,
                    size: 100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.timerSuccessKicker,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.timerSuccessTitle,
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
