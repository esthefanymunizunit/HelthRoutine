import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProgressCircleSection extends StatelessWidget {
  const ProgressCircleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/progres-circle-section.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
