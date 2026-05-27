import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';

class MoodCalendarPage extends StatelessWidget {
  const MoodCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Ocupa apenas o necessário
                      children: [
                        const _HighlightedTitle(
                          leading: AppStrings.moodTitleLeading,
                          highlighted: AppStrings.moodTitleHighlighted,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppStrings.moodDateMock,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 18),
                ],
              ),
              const SizedBox(height: 24),

              const _WeekdayRow(),
              const SizedBox(height: 10),

              const _MoodCalendarGrid(),
              const SizedBox(height: 18),

              const _MonthMoodCard(),
              const SizedBox(height: 24),

              const _StatsRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedTitle extends StatelessWidget {
  final String leading;
  final String highlighted;

  const _HighlightedTitle({required this.leading, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = AppTextStyles.heading1.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: '$leading '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.starYellow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(highlighted, style: baseStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppStrings.weekdaysShort
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MoodCalendarGrid extends StatelessWidget {
  const _MoodCalendarGrid();

  static const List<_MoodType?> _moods = [
    null,
    null,
    _MoodType.calm,
    _MoodType.calm,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.angry,
    null,
    _MoodType.anxious,
    _MoodType.alert,
    _MoodType.angry,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.happy,
    null,
    null,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.happy,
    _MoodType.angry,
    _MoodType.happy,
    _MoodType.happy,
    _MoodType.calm,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.anxious,
    _MoodType.anxious,
    _MoodType.calm,
    _MoodType.happy,
    _MoodType.angry,
    null,
    null,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _moods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final mood = _moods[index];
        return _MoodDayCell(mood: mood);
      },
    );
  }
}

class _MoodDayCell extends StatelessWidget {
  final _MoodType? mood;

  const _MoodDayCell({required this.mood});

  // Função para retornar o caminho correto da imagem baseada no humor
  String _getIconPath(_MoodType type) {
    switch (type) {
      case _MoodType.happy:
        return 'assets/images/icon-animada.png';
      case _MoodType.calm:
        return 'assets/images/icon-sensivel.png';
      case _MoodType.angry:
        return 'assets/images/icon-brava.png';
      case _MoodType.anxious:
        return 'assets/images/icon-insegura.png';
      case _MoodType.alert:
        return 'assets/images/icon-alerta.png'; // Verifique se este nome está correto no seu projeto
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fillColor = _MoodPalette.colorFor(mood);

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: mood == null
          ? null
          // O Padding garante que a imagem tenha uma margem de respiro e não toque as bordas do quadrado
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                _getIconPath(mood!),
                fit: BoxFit
                    .contain, // Mantém a proporção da imagem sem distorcer
              ),
            ),
    );
  }
}

enum _MoodType { happy, calm, angry, anxious, alert }

class _MoodPalette {
  static Color colorFor(_MoodType? mood) {
    switch (mood) {
      case _MoodType.happy:
        return AppColors.moodAnimada;
      case _MoodType.calm:
        return AppColors.moodSensivel;
      case _MoodType.angry:
        return AppColors.moodBrava;
      case _MoodType.anxious:
        return AppColors.moodInsegura;
      case _MoodType.alert:
        return AppColors.alertRed;
      default:
        return const Color(0xFFF1F1F1);
    }
  }
}

class _MonthMoodCard extends StatelessWidget {
  const _MonthMoodCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.moodAnimada,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.moodMonthTitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.moodMonthStatus,
                  style: AppTextStyles.heading1.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.moodMonthDescription,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black87,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Imagem grande no card de resumo substituindo o antigo CustomPainter
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/images/icon-animada.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _StatItem(
          title: AppStrings.physicalActivity,
          value: AppStrings.statStepsValueMock,
          subtitle: AppStrings.statStepsSubtitle,
        ),
        _StatItem(
          title: AppStrings.statMeditationTitle,
          value: AppStrings.statMeditationValueMock,
          subtitle: AppStrings.statMeditationSubtitle,
        ),
        _StatItem(
          title: AppStrings.statDisciplineTitle,
          value: AppStrings.statDisciplineValueMock,
          subtitle: AppStrings.statDisciplineSubtitle,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatItem({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Text(value, style: AppTextStyles.heading1.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
