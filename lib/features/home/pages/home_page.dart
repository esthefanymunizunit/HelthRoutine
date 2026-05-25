import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

import '../widgets/mood_icon.dart';
import '../widgets/activity_card.dart';
import '../widgets/suggestion_card.dart';
import '../widgets/low_energy_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLowEnergyMode = false;

  Map<String, dynamic>? mockData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/mocks/home_mock.json',
      );
      final data = await json.decode(response);
      setState(() {
        mockData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar o mock: $e");
    }
  }

  Color _getColor(String colorKey) {
    switch (colorKey) {
      case 'pink':
        return AppColors.activityPink;
      case 'blue':
        return AppColors.activityBlue;
      case 'green':
        return AppColors.activityGreen;
      default:
        return AppColors.white;
    }
  }

  void _toggleLowEnergyMode() async {
    if (isLowEnergyMode) {
      setState(() => isLowEnergyMode = false);
    } else {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => const LowEnergyDialog(),
      );
      if (confirm == true) {
        setState(() => isLowEnergyMode = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.blueVariant),
        ),
      );
    }

    final List<dynamic> currentActivities = isLowEnergyMode
        ? mockData!['lowEnergyActivities']
        : mockData!['normalActivities'];

    final List<dynamic> currentSuggestions = mockData!['suggestions'];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABEÇALHO (Header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.greeting,
                          style: AppTextStyles.heading1,
                        ),
                        const SizedBox(width: 8),
                        // Imagem da estrela customizada
                        Image.asset(
                          'assets/images/estrela1.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    // ALTERADO: Ícone genérico substituído pela imagem de perfil
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      // Forma padrão do Flutter para imagem de perfil arredondada
                      backgroundImage: AssetImage(
                        'assets/images/icon-perfil.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                isLowEnergyMode ? _buildLowEnergyBanner() : _buildCheckInCard(),
                const SizedBox(height: 32),

                // SEÇÃO ATIVIDADES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.activitiesTitle,
                      style: AppTextStyles.heading2,
                    ),
                    GestureDetector(
                      onTap: _toggleLowEnergyMode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isLowEnergyMode
                              ? AppStrings.btnDisable
                              : AppStrings.btnLowEnergy,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // LISTA DE ATIVIDADES
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: currentActivities
                        .map(
                          (activity) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ActivityCard(
                              color: _getColor(activity['colorKey']),
                              title: activity['title'],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 32),

                // SEÇÃO SUGESTÕES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.suggestionsTitle,
                      style: AppTextStyles.heading2.copyWith(fontSize: 14),
                    ),
                    const Text(
                      AppStrings.btnSeeAll,
                      style: TextStyle(
                        color: AppColors.cloudBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: currentSuggestions
                      .map(
                        (sug) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: sug == currentSuggestions.first ? 16.0 : 0,
                            ),
                            child: SuggestionCard(
                              title: sug['title'],
                              subtitle: sug['subtitle'],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 80,
                ), // Espaço para o FAB não cobrir conteúdo
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.checkInTitle, style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text(AppStrings.checkInSubtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoodIcon(
                color: AppColors.moodAnimada,
                label: 'Animada',
                imagePath: 'assets/images/icon-animada.png',
              ),
              MoodIcon(
                color: AppColors.moodSensivel,
                label: 'Sensível',
                imagePath: 'assets/images/icon-sensivel.png',
              ),
              MoodIcon(
                color: AppColors.moodBrava,
                label: 'Brava',
                imagePath: 'assets/images/icon-brava.png',
              ),
              MoodIcon(
                color: AppColors.moodInsegura,
                label: 'Insegura',
                imagePath: 'assets/images/icon-insegura.png',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLowEnergyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.moodInsegura,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.lowEnergyBannerTitle,
            style: AppTextStyles.heading2.copyWith(color: AppColors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.lowEnergyBannerSubtitle,
            style: AppTextStyles.bodyBold.copyWith(
              color: AppColors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
