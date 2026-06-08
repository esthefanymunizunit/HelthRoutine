import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthroutine/features/tasks/pages/creeate_task_page.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

import 'package:healthroutine/features/feature-template/services/rotina_service.dart';
import '../../tasks/services/task_service.dart';

import '../../calendar/pages/mood_calendar_page.dart';
import '../../timer/pages/timer_page.dart';
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
  final RotinaService _rotinaService = RotinaService();
  final TaskService _taskService = TaskService();

  bool isLowEnergyMode = false;
  Map<String, dynamic>? mockData;
  bool isLoading = true;

  final Set<String> _activitiesCompletedViaTimer = <String>{};

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _rotinaService.seedPadraoSeVazio().catchError(
      (e) => debugPrint('Erro ao semear: $e'),
    );
    _rotinaService.limparExpiradas().catchError(
      (e) => debugPrint('Erro ao limpar: $e'),
    );
  }

  String get _saudacao {
    final user = FirebaseAuth.instance.currentUser;
    final base = user?.displayName ?? user?.email ?? '';
    if (base.isEmpty) return 'Olá!';
    return 'Olá, ${base.split('@').first.split(' ').first} !';
  }

  Color _hexToColor(String hex) {
    var h = hex.replaceFirst('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
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
        return AppColors.activityBlue;
    }
  }

  Future<void> _loadMockData() async {
    try {
      final response = await rootBundle.loadString(
        'assets/mocks/home_mock.json',
      );
      if (!mounted) return;
      setState(() {
        mockData = json.decode(response);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar o mock: $e");
    }
  }


  Future<void> _onCircleRotina(Atividade a) async {
    if (a.hasTimer) {
      final completou = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => TimerPage(
            taskTitle: a.title,
            workDurationMinutes: a.timerDurationMinutes,
            isPomodoro: a.isPomodoro,
          ),
        ),
      );
      if (completou == true) await _rotinaService.definirConcluida(a.id, true);
    } else {
      await _rotinaService.definirConcluida(a.id, !a.concluida); 
    }
  }

  Future<void> _onCircleTask(TaskModel task) async {
    if (task.hasTimer) {
      final completou = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => TimerPage(
            taskTitle: task.title,
            workDurationMinutes: task.timerDurationMinutes,
            isPomodoro: task.isPomodoro,
          ),
        ),
      );
      if (completou == true) await _taskService.toggleConcluida(task.id, true);
    } else {
      await _taskService.toggleConcluida(
        task.id,
        !task.concluida,
      ); 
    }
  }

  Future<void> _removerRotina(Atividade a) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover Template'),
        content: Text('Apagar "${a.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (ok == true) await _rotinaService.remover(a.id);
  }

  Future<void> _removerTask(TaskModel task) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover Tarefa'),
        content: Text('Apagar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (ok == true) await _taskService.deleteTask(task.id);
  }

  void _abrirCriarEditarTarefa({TaskModel? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: CreateTaskPage(
          isEditing: task != null,
          initialTitle: task?.title,
          taskId: task?.id,
        ),
      ),
    );
  }

  Future<void> _handleLowEnergyCircle(Map<String, dynamic> activity) async {
    final String title = activity['title'] as String;
    if (_activitiesCompletedViaTimer.contains(title)) {
      setState(() => _activitiesCompletedViaTimer.remove(title));
      return;
    }
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TimerPage(
          taskTitle: title,
          workDurationMinutes: activity['timerDurationMinutes'] as int?,
          isPomodoro: activity['isPomodoro'] == true,
        ),
      ),
    );
    if (!mounted) return;
    if (completed == true)
      setState(() => _activitiesCompletedViaTimer.add(title));
  }

  void _openMoodCalendarPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MoodCalendarPage()));
  }

  void _toggleLowEnergyMode() async {
    if (isLowEnergyMode) {
      setState(() => isLowEnergyMode = false);
    } else {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => const LowEnergyDialog(),
      );
      if (confirm == true) setState(() => isLowEnergyMode = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.blueVariant),
        ),
      );

    final List<dynamic> currentSuggestions = mockData!['suggestions'];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(_saudacao, style: AppTextStyles.heading1),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/images/estrela1.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'assets/images/icon-perfil.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                isLowEnergyMode ? _buildLowEnergyBanner() : _buildCheckInCard(),
                const SizedBox(height: 32),
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

                isLowEnergyMode
                    ? _buildLowEnergyActivities()
                    : _buildFirestoreActivities(),

                const SizedBox(height: 32),
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isLowEnergyMode
          ? null
          : FloatingActionButton(
              onPressed: () => _abrirCriarEditarTarefa(),
              backgroundColor: AppColors.blueVariant,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }

  Widget _buildFirestoreActivities() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: StreamBuilder<List<Atividade>>(
        stream: _rotinaService.ouvirAtividades(),
        builder: (context, rotinaSnap) {
          return StreamBuilder<List<TaskModel>>(
            stream: _taskService.ouvirTasks(),
            builder: (context, taskSnap) {
              if (rotinaSnap.connectionState == ConnectionState.waiting &&
                  taskSnap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final rotinas = rotinaSnap.data ?? [];
              final tasks = taskSnap.data ?? [];
              final todasAsAtividades = [...rotinas, ...tasks];

              if (todasAsAtividades.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Sem atividades ainda. Crie um template ou uma nova tarefa abaixo.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                );
              }


              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: todasAsAtividades.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = todasAsAtividades[index];

                  if (item is Atividade) {
                    return GestureDetector(
                      onLongPress: () => _removerRotina(item),
                      child: ActivityCard(
                        key: ValueKey('rotina_${item.id}'),
                        color: _hexToColor(item.cor),
                        title: item.title,
                        isExternallyCompleted:
                            item.concluida, 
                        onCirclePressed: () => _onCircleRotina(item),
                        onEdited: null, 
                      ),
                    );
                  } else if (item is TaskModel) {
                    return GestureDetector(
                      onLongPress: () => _removerTask(item),
                      child: ActivityCard(
                        key: ValueKey('task_${item.id}'),
                        color: _getColor(item.colorKey),
                        title: item.title,
                        isExternallyCompleted:
                            item.concluida, 
                        onCirclePressed: () => _onCircleTask(item),
                        onEdited: () => _abrirCriarEditarTarefa(
                          task: item,
                        ), 
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLowEnergyActivities() {
    final List<dynamic> atividades = mockData!['lowEnergyActivities'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: atividades.map((activity) {
          final String title = activity['title'] as String;
          final bool temTimer = activity['hasTimer'] == true;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ActivityCard(
              color: _getColor(activity['colorKey']),
              title: title,
              isExternallyCompleted: _activitiesCompletedViaTimer.contains(
                title,
              ),
              onCirclePressed: temTimer
                  ? () =>
                        _handleLowEnergyCircle(activity as Map<String, dynamic>)
                  : null,
              onEdited: null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCheckInCard() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openMoodCalendarPage,
      child: Container(
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
