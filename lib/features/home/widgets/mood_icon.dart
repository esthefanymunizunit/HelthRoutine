import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MoodIcon extends StatelessWidget {
  final Color color;
  final String label;
  final String imagePath;
  final VoidCallback? onTap; // <-- Isso avisa que ele pode ser clicado!

  const MoodIcon({
    super.key,
    required this.color,
    required this.label,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // O clique acontece aqui e é repassado para a Home
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
