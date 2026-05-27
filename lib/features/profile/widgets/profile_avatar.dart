import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle, 
            color: AppColors.borderBlue,
          ),
          child: CircleAvatar(
            radius: 70,
            backgroundColor: AppColors.white,
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/icons/user.svg',
                width: 140,
                height: 140,
              ),
            ),
          ),
        ),
        // Botão da câmera
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.borderBlue,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined, 
              color: Colors.black, 
              size: 20,
            ),
            onPressed: () {
              // Lógica para trocar foto no futuro
            },
          ),
        ),
      ],
    );
  }
}