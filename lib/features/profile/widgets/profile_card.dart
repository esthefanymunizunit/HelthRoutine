import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.showEditButton = false,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.cloudBlue),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),
              ...children,
            ],
          ),
        ),
        if (showEditButton)
          Positioned(
            bottom: -20,
            child: FloatingActionButton.small(
              onPressed: onEditPressed,
              backgroundColor: AppColors.cloudBlue,
              shape: CircleBorder(),
              child: const Icon(Icons.edit, color: Colors.black),
            ),
          ),
      ],
    );
  }
}