import 'package:flutter/material.dart';
import 'package:healthroutine/features/tasks/pages/creeate_task_page.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import 'bottom_nav_icon.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.cloudBlue,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => onTap(0),
              child: BottomNavIcon(
                icon: Icons.home_filled,
                label: AppStrings.navHome,
                isSelected: currentIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => onTap(1),
              child: BottomNavIcon(
                icon: Icons.list,
                label: AppStrings.navTemplates,
                isSelected: currentIndex == 1,
              ),
            ),
            const SizedBox(width: 48),
            GestureDetector(
              onTap: () => onTap(2),
              child: BottomNavIcon(
                icon: Icons.bar_chart,
                label: AppStrings.navReports,
                isSelected: currentIndex == 2,
              ),
            ),
            GestureDetector(
              onTap: () => onTap(3),
              child: BottomNavIcon(
                icon: Icons.person_outline,
                label: AppStrings.navProfile,
                isSelected: currentIndex == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
