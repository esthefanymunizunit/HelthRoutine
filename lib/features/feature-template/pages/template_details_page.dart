import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart'; 
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../widgets/template_task_card.dart';

class TemplateDetailsPage extends StatefulWidget {
  final String title;
  final Color color;
  final List<Map<String, String>> tasks;

  const TemplateDetailsPage({
    super.key,
    required this.title,
    required this.color,
    required this.tasks,
  });

  @override
  State<TemplateDetailsPage> createState() => _TemplateDetailsPageState();
}

class _TemplateDetailsPageState extends State<TemplateDetailsPage> {
  List<Map<String, dynamic>> _localTasks = [];

  @override
  void initState() {
    super.initState();
    _localTasks = widget.tasks.map((task) {
      return {
        'title': task['title'],
        'start': task['start'],
        'end': task['end'],
        'hasNotification': true,
      };
    }).toList();
  }

  Future<void> _pickTime(int index, String timeKey) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _localTasks[index][timeKey] = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.title, style: AppTextStyles.heading1),
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/images/icon-perfil.png'),
                    ),
                  ],
                ),
              ),

              // FUNDO BRANCO CENTRAL
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Sub-header com botão de voltar
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.templatePersonalizeTitle, // MUDANÇA AQUI
                            style: AppTextStyles.heading2.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // LISTA DE TAREFAS
                      Expanded(
                        child: ListView.builder(
                          itemCount: _localTasks.length,
                          itemBuilder: (context, index) {
                            return TemplateTaskCard(
                              task: _localTasks[index],
                              themeColor: widget.color,
                              onDelete: () {
                                setState(() {
                                  _localTasks.removeAt(index);
                                });
                              },
                              onStartTapped: () => _pickTime(index, 'start'),
                              onEndTapped: () => _pickTime(index, 'end'),
                              onNotificationToggled: () {
                                setState(() {
                                  _localTasks[index]['hasNotification'] =
                                      !_localTasks[index]['hasNotification'];
                                });
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BOTÃO ADICIONAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.color,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppStrings.templateAddRoutineBtn, // MUDANÇA AQUI
                            style: AppTextStyles.bodyBold.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}