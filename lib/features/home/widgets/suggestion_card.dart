import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SuggestionCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const SuggestionCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMeditation = title.toLowerCase().contains('medita');

    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 14)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.bodySmall),
          ],
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: isMeditation
                ? Image.asset(
                    'assets/images/icon-nuvem-feliz.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Icons.stars,
                    color: AppColors.starYellow,
                    size: 32,
                  ),
          ),
        ],
      ),
    );
  }
}
