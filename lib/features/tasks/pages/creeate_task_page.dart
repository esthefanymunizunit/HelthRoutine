import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../widgets/task_form_label.dart';
import '../widgets/task_dropdown_button.dart';
import '../widgets/day_selector_button.dart';
import '../widgets/success_dialog.dart'; // Import da nossa nova animação!

class CreateTaskPage extends StatefulWidget {
  final bool isEditing;
  final String? initialTitle;

  const CreateTaskPage({super.key, this.isEditing = false, this.initialTitle});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late TextEditingController _titleController;

  bool isEssential = true;
  bool hasTimer = false;
  bool hasNotifications = true;

  DateTime? selectedDate;

  List<bool> selectedDays = [false, false, true, false, true, false, false];
  final List<String> daysOfWeek = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  String get formattedDate {
    if (selectedDate == null) return AppStrings.addDateBtn;
    String day = selectedDate!.day.toString().padLeft(2, '0');
    String month = selectedDate!.month.toString().padLeft(2, '0');
    return "$day/$month/${selectedDate!.year}";
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundOffWhite,
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isEditing ? 'Editar Tarefa' : AppStrings.newTaskTitle,
                style: AppTextStyles.heading1,
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A estrela agora rola junto com o formulário
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Image.asset(
                        'assets/images/estrela-tarefa.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Nome da Tarefa
                  const TaskFormLabel(text: AppStrings.taskNameLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: AppColors.black),
                    decoration: InputDecoration(
                      hintText: AppStrings.taskNameHint,
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TaskFormLabel(text: AppStrings.essentialLabel),
                      Checkbox(
                        value: isEssential,
                        activeColor: AppColors.blueVariant,
                        onChanged: (value) =>
                            setState(() => isEssential = value!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const TaskFormLabel(text: AppStrings.untilLabel),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TaskDropdownButton(
                          label: formattedDate,
                          icon: Icons.calendar_today,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TaskDropdownButton(
                          label: AppStrings.quantityBtn,
                          icon: Icons.keyboard_arrow_down,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Repetir em
                  const TaskFormLabel(text: AppStrings.repeatLabel),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(daysOfWeek.length, (index) {
                      return DaySelectorButton(
                        day: daysOfWeek[index],
                        isSelected: selectedDays[index],
                        onTap: () {
                          setState(() {
                            selectedDays[index] = !selectedDays[index];
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TaskFormLabel(text: AppStrings.addTimerLabel),
                      CupertinoSwitch(
                        value: hasTimer,
                        activeColor: AppColors.blueVariant,
                        onChanged: (val) => setState(() => hasTimer = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TaskFormLabel(text: AppStrings.notificationsLabel),
                      CupertinoSwitch(
                        value: hasNotifications,
                        activeColor: AppColors.blueVariant,
                        onChanged: (val) =>
                            setState(() => hasNotifications = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Botão Adicionar/Salvar Tarefa com Animação
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Oculta o teclado
                        FocusScope.of(context).unfocus();

                        // 2. Exibe o modal animado de sucesso
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const SuccessDialog(),
                        ).then((_) {
                          // 3. Após fechar o modal, fecha a própria tela
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueVariant,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        widget.isEditing
                            ? 'Salvar Edição'
                            : AppStrings.btnAddTask,
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
