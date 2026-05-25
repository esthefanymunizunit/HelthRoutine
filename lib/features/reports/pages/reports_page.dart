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

                const ProgressCircleSection(),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.weeklySummary,
                      style: AppTextStyles.heading2.copyWith(fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: AppColors.cloudBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.weeklyComparison,
                            style: const TextStyle(
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

                WeeklyBarChart(data: mockData!['weeklyChart']),
                const SizedBox(height: 32),

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
                      // Sua imagem roxa exportada do Figma
                      Image.asset(
                        'assets/images/icon-roxo-feliz.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
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
