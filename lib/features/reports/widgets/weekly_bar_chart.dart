import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<dynamic> data;
  const WeeklyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Adiciona a linha de base preta (Eixo X) igual ao design
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.black, width: 1.5)),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final isHighlighted = item['highlight'] == true;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20, // Barras mais gordinhas como no design
                height: 120 * (item['value'] as double),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? AppColors.cloudBlue
                      : const Color(0xFF53B4E0).withOpacity(0.5),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['day'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
