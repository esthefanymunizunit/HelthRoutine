import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'time_chip.dart'; 

class TemplateTaskCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final Color themeColor;
  final VoidCallback onDelete;
  final VoidCallback onStartTapped;
  final VoidCallback onEndTapped;
  final VoidCallback onNotificationToggled;

  const TemplateTaskCard({
    super.key,
    required this.task,
    required this.themeColor,
    required this.onDelete,
    required this.onStartTapped,
    required this.onEndTapped,
    required this.onNotificationToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundOffWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task['title'] ?? '',
                  style: AppTextStyles.bodyBold.copyWith(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline,
                  color: themeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                "Horário : ",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
              ),
              TimeChip(
                time: task['start'] ?? '',
                onTap: onStartTapped,
              ),
              const Text("  -  ", style: TextStyle(color: Colors.black)),
              TimeChip(
                time: task['end'] ?? '',
                onTap: onEndTapped,
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onNotificationToggled,
            child: Row(
              children: [
                Icon(
                  task['hasNotification'] == true ? Icons.check_box : Icons.check_box_outline_blank,
                  color: themeColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Notificações",
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}