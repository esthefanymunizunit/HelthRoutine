import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final String label;
  final String? subLabel;
  final Widget? trailing;
  final bool showArrow;

  const ProfileMenuTile({
    super.key,
    required this.label,
    this.subLabel,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
          if (trailing != null)
            trailing!
          else if (showArrow)
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.cloudBlue)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}