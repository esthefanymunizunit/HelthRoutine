import 'package:flutter/material.dart';
import 'package:healthroutine/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.borderBlue),
          child: const CircleAvatar(
            radius: 70,
            backgroundColor: Color(0xFFFFE4D1),
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.borderBlue,
          child: IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 20),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}