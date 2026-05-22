import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class TaskFormLabel extends StatelessWidget {
  final String text;

  const TaskFormLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyBold.copyWith(color: Colors.grey.shade600),
    );
  }
}