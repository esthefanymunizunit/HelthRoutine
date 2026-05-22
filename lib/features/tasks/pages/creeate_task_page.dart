import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../widgets/task_form_label.dart';
import '../widgets/task_dropdown_button.dart';
import '../widgets/day_selector_button.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
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
              Text(AppStrings.newTaskTitle, style: AppTextStyles.heading1),
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

          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Icon(
                Icons.face_retouching_natural,
                color: AppColors.starYellow,
                size: 64,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome da Tarefa
                  const TaskFormLabel(text: AppStrings.taskNameLabel),
                  const SizedBox(height: 8),
                  TextField(
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

                  // Botão Adicionar Tarefa
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                        AppStrings.btnAddTask,
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
