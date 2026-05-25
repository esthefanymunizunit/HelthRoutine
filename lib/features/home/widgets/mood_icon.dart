import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MoodIcon extends StatelessWidget {
  final Color color;
  final String label;
  final String imagePath; // <-- Trocado de IconData para String

  const MoodIcon({
    super.key,
    required this.color,
    required this.label,
    required this.imagePath, // <-- Atualizado aqui
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(
            12,
          ), // Espaçamento interno para a imagem respirar
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          // ALTERADO: Usando Image.asset no lugar do Icon
          child: Image.asset(imagePath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
