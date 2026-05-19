import 'package:flutter/material.dart';

// Imports do Core
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

// Imports dos Widgets da Feature Home
import '../widgets/mood_icon.dart';
import '../widgets/activity_card.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/bottom_nav_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- CABEÇALHO ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Olá, Mariana !', style: AppTextStyles.heading1),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.face_retouching_natural,
                          color: AppColors.starYellow,
                          size: 32,
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: AppColors.activityBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- CARD DE CHECK-IN ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in', style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(
                        'Como você está hoje?',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MoodIcon(
                            color: AppColors.moodAnimada,
                            label: 'Animada',
                            icon: Icons.sentiment_satisfied_alt,
                          ),
                          MoodIcon(
                            color: AppColors.moodSensivel,
                            label: 'Sensível',
                            icon: Icons.sentiment_neutral,
                          ),
                          MoodIcon(
                            color: AppColors.moodBrava,
                            label: 'Brava',
                            icon: Icons.sentiment_very_dissatisfied,
                          ),
                          MoodIcon(
                            color: AppColors.moodInsegura,
                            label: 'Insegura',
                            icon: Icons.remove_red_eye,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- ATIVIDADES DE HOJE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Atividades de Hoje', style: AppTextStyles.heading2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Baixa energia',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de Atividades
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Column(
                    children: [
                      ActivityCard(
                        color: AppColors.activityPink,
                        title: 'Caminhar com o cachorro',
                      ),
                      SizedBox(height: 12),
                      ActivityCard(
                        color: AppColors.activityBlue,
                        title: 'Estudar',
                      ),
                      SizedBox(height: 12),
                      ActivityCard(
                        color: AppColors.activityGreen,
                        title: 'Meditação Rápida',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- SUGERIDO PARA VOCÊ ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sugerido para você',
                      style: AppTextStyles.heading2.copyWith(fontSize: 14),
                    ),
                    const Text(
                      'Ver todas',
                      style: TextStyle(
                        color: AppColors.cloudBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(
                      child: SuggestionCard(
                        title: 'Dica de nutrição',
                        subtitle: 'Alimentos que ajudam...',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SuggestionCard(
                        title: 'Técnica de meditação',
                        subtitle: '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.starYellow, size: 32),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: AppColors.cloudBlue,
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavIcon(
                icon: Icons.home_filled,
                label: 'Home',
                isSelected: true,
              ),
              BottomNavIcon(icon: Icons.list, label: 'Templates'),
              SizedBox(width: 48),
              BottomNavIcon(icon: Icons.bar_chart, label: 'Relatórios'),
              BottomNavIcon(icon: Icons.person_outline, label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
