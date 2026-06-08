import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ActivityCard extends StatelessWidget {
  final Color color;
  final String title;
  final bool isExternallyCompleted; 
  final VoidCallback? onCirclePressed;
  final VoidCallback? onEdited;

  const ActivityCard({
    super.key,
    required this.color,
    required this.title,
    this.isExternallyCompleted = false,
    this.onCirclePressed,
    this.onEdited,
  });

  @override
  Widget build(BuildContext context) {
    const Color completedColor = Color(0xFF53B4E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCirclePressed, 
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isExternallyCompleted ? completedColor : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: isExternallyCompleted
                  ? const Icon(Icons.check, color: AppColors.white, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyBold.copyWith(
                decoration: isExternallyCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: completedColor,
                decorationThickness: 2.0,
              ),
            ),
          ),


          if (onEdited != null)
            GestureDetector(
              onTap: onEdited,
              child: const Icon(
                Icons.edit,
                color: AppColors.black,
                size: 20,
              ), 
            ),
        ],
      ),
    );
  }
}
