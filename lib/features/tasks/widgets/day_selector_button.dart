import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DaySelectorButton extends StatelessWidget {
  final String day;
  final bool isSelected;
  final VoidCallback onTap;

  const DaySelectorButton({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.black : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          day,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}