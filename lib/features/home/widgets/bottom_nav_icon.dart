import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const BottomNavIcon({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.softYellow : AppColors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
