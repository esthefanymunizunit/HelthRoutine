import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../widgets/progress_circle_section.dart';
import '../widgets/weekly_bar_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
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
        'assets/mocks/reports_mock.json',
      );
      setState(() {
        mockData = json.decode(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar o mock: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || mockData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(AppStrings.reportsTitle, style: AppTextStyles.heading1),
                const SizedBox(height: 4),
                Text(
                  AppStrings.reportsSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                // Círculos de Progresso (Agora fiéis ao design)
                const ProgressCircleSection(),
                const SizedBox(height: 40),

                // Resumo Semanal e Tag flutuante
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.weeklySummary,
                      style: AppTextStyles.heading2.copyWith(fontSize: 14),
                    ),
                    // Tag "+10% vs semana passada"
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: AppColors.cloudBlue,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+10% vs semana passada',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Gráfico de Barras com a linha base
                WeeklyBarChart(data: mockData!['weeklyChart']),
                const SizedBox(height: 32),

                // Cards de estatísticas (Domingo Reset e Atividade)
                Row(
                  children: [
                    _buildSmallStatCard(
                      title: AppStrings.sundayReset,
                      value: mockData!['stats']['sundayReset'] ?? "3/4",
                      color: AppColors.softYellow,
                      isCircular: false,
                    ),
                    const SizedBox(width: 16),
                    _buildSmallStatCard(
                      title: AppStrings.physicalActivity,
                      value: mockData!['stats']['activity'] ?? "85%",
                      color: AppColors.cloudBlue,
                      isCircular: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Insight Card (Agora branco com borda, igual ao Figma)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.insightTitle,
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mockData!['insight'],
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ícone roxo do design
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.templatePurpleLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.sentiment_satisfied_alt,
                          size: 32,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Atualizado para suportar barra linear ou barra circular
  Widget _buildSmallStatCard({
    required String title,
    required String value,
    required Color color,
    required bool isCircular,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: AppTextStyles.heading1.copyWith(fontSize: 24),
                ),
                if (isCircular)
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      color: color,
                      backgroundColor: Colors.grey.shade200,
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          minHeight: 10,
                          color: color,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
