import 'package:flutter/material.dart';
import 'package:healthroutine/features/tasks/pages/creeate_task_page.dart'; // Corrija o import se necessário
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import 'bottom_nav_icon.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.cloudBlue,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BottomNavIcon(icon: Icons.home_filled, label: AppStrings.navHome, isSelected: true),
            BottomNavIcon(icon: Icons.list, label: AppStrings.navTemplates),
            SizedBox(width: 48), // Espaço vazio para o FAB
            BottomNavIcon(icon: Icons.bar_chart, label: AppStrings.navReports),
            BottomNavIcon(icon: Icons.person_outline, label: AppStrings.navProfile),
          ],
        ),
      ),
    );
  }

  // Método estático para padronizar o botão flutuante em todas as telas
  static FloatingActionButton buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: CreateTaskPage(),
          ),
        );
      },
      backgroundColor: AppColors.black,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: AppColors.starYellow, size: 32),
    );
  }
}