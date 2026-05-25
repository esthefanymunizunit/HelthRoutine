import 'package:flutter/material.dart';
import 'package:healthroutine/features/tasks/pages/creeate_task_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ActivityCard extends StatefulWidget {
  final Color color;
  final String title;

  const ActivityCard({super.key, required this.color, required this.title});

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    const Color completedColor = Color(0xFF53B4E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCompleted = !isCompleted;
              });
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? completedColor : AppColors.white,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: AppColors.white, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Text(
              widget.title,
              style: AppTextStyles.bodyBold.copyWith(
                decoration: isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: completedColor,
                decorationThickness: 2.0,
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: CreateTaskPage(
                    isEditing: true,
                    initialTitle: widget.title,
                  ),
                ),
              );
            },
            child: const Icon(Icons.edit, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
