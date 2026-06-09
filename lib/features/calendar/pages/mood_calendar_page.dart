import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../services/mood_service.dart';
// Importando o MoodIcon para reaproveitar os botões bonitos da Home!
import '../../home/widgets/mood_icon.dart'; 

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
                      mainAxisSize: MainAxisSize.min,
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

              // INTEGRAÇÃO REAL COM FIREBASE AQUI
              StreamBuilder<List<MoodModel>>(
                stream: MoodService().ouvirHumores(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final moods = snapshot.data ?? [];
                  return _MoodCalendarGrid(moods: moods);
                },
              ),

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
  final List<MoodModel> moods;

  const _MoodCalendarGrid({required this.moods});

  // ABERTURA DO BOTTOM SHEET QUANDO CLICAR NUM DIA VAZIO
  void _mostrarBottomSheetDeHumor(BuildContext context, DateTime dataSelecionada) {
    final moodService = MoodService();
    
    // Mostra o modal de baixo para cima
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Como você estava no dia ${dataSelecionada.day}?',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MoodIcon(
                  color: AppColors.moodAnimada,
                  label: 'Animada',
                  imagePath: 'assets/images/icon-animada.png',
                  onTap: () {
                    moodService.registrarHumor('happy', dataDesejada: dataSelecionada);
                    Navigator.pop(context);
                  },
                ),
                MoodIcon(
                  color: AppColors.moodSensivel,
                  label: 'Sensível',
                  imagePath: 'assets/images/icon-sensivel.png',
                  onTap: () {
                    moodService.registrarHumor('calm', dataDesejada: dataSelecionada);
                    Navigator.pop(context);
                  },
                ),
                MoodIcon(
                  color: AppColors.moodBrava,
                  label: 'Brava',
                  imagePath: 'assets/images/icon-brava.png',
                  onTap: () {
                    moodService.registrarHumor('angry', dataDesejada: dataSelecionada);
                    Navigator.pop(context);
                  },
                ),
                MoodIcon(
                  color: AppColors.moodInsegura,
                  label: 'Insegura',
                  imagePath: 'assets/images/icon-insegura.png',
                  onTap: () {
                    moodService.registrarHumor('anxious', dataDesejada: dataSelecionada);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    int offset = firstDayOfMonth.weekday;
    if (offset == 7) offset = 0;

    final List<_MoodType?> grid = List.generate(42, (index) {
      if (index < offset || index >= offset + daysInMonth) return null;
      final day = index - offset + 1;

      try {
        final moodForDay = moods.firstWhere(
          (m) =>
              m.date.year == now.year &&
              m.date.month == now.month &&
              m.date.day == day,
        );
        return _stringToMoodType(moodForDay.type);
      } catch (_) {
        return null; // Retorna null se não houver humor preenchido
      }
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final mood = grid[index];
        final bool isValidDay = (index >= offset && index < offset + daysInMonth);
        final int dayNumber = index - offset + 1;
        
        // Criamos a data exata daquele quadradinho (se for um dia válido)
        final DateTime? dataDoQuadradinho = isValidDay 
            ? DateTime(now.year, now.month, dayNumber) 
            : null;

        return GestureDetector(
          // Se for um dia válido (mesmo passado ou futuro) e estiver sem humor ou a pessoa quiser trocar
          onTap: () {
            if (isValidDay && dataDoQuadradinho != null) {
              // Só não deixa preencher dias que ainda não chegaram (se quiser bloquear o futuro)
              if (dataDoQuadradinho.isAfter(now)) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Você não pode prever o futuro! 🔮')),
                );
              } else {
                 _mostrarBottomSheetDeHumor(context, dataDoQuadradinho);
              }
            }
          },
          child: _MoodDayCell(
            mood: mood, 
            isValidDay: isValidDay, 
            dayNumber: dayNumber, // Passamos o número para desenhar na tela se estiver vazio
          ),
        );
      },
    );
  }

  _MoodType _stringToMoodType(String type) {
    switch (type) {
      case 'happy': return _MoodType.happy;
      case 'calm': return _MoodType.calm;
      case 'angry': return _MoodType.angry;
      case 'anxious': return _MoodType.anxious;
      case 'alert': return _MoodType.alert;
      default: return _MoodType.happy;
    }
  }
}

class _MoodDayCell extends StatelessWidget {
  final _MoodType? mood;
  final bool isValidDay;
  final int dayNumber;

  const _MoodDayCell({required this.mood, required this.isValidDay, required this.dayNumber});

  String _getIconPath(_MoodType type) {
    switch (type) {
      case _MoodType.happy: return 'assets/images/icon-animada.png';
      case _MoodType.calm: return 'assets/images/icon-sensivel.png';
      case _MoodType.angry: return 'assets/images/icon-brava.png';
      case _MoodType.anxious: return 'assets/images/icon-insegura.png';
      case _MoodType.alert: return 'assets/images/icon-alerta.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fillColor = mood != null
        ? _MoodPalette.colorFor(mood)
        : (isValidDay ? const Color(0xFFF1F1F1) : Colors.transparent);

    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      // Se não tiver humor, mas for um dia válido, mostra o número do dia cinza claro
      child: mood == null
          ? (isValidDay 
              ? Center(child: Text('$dayNumber', style: const TextStyle(color: Colors.black26, fontWeight: FontWeight.bold))) 
              : null)
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(_getIconPath(mood!), fit: BoxFit.contain),
            ),
    );
  }
}

enum _MoodType { happy, calm, angry, anxious, alert }

class _MoodPalette {
  static Color colorFor(_MoodType? mood) {
    switch (mood) {
      case _MoodType.happy: return AppColors.moodAnimada;
      case _MoodType.calm: return AppColors.moodSensivel;
      case _MoodType.angry: return AppColors.moodBrava;
      case _MoodType.anxious: return AppColors.moodInsegura;
      case _MoodType.alert: return AppColors.alertRed;
      default: return const Color(0xFFF1F1F1);
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
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset('assets/images/icon-animada.png', fit: BoxFit.contain),
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