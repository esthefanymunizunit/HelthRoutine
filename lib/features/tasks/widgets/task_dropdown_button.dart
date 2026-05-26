import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TaskDropdownButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap; // Adicionamos a propriedade de clique

  const TaskDropdownButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap, // Recebe o clique quando o widget for chamado
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, color: Colors.grey.shade600, size: 18),
          ],
        ),
      ),
    );
  }
}
