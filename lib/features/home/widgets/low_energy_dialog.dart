import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LowEnergyDialog extends StatelessWidget {
  const LowEnergyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Caixinha branca do modal
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ativar Modo Baixa Energia ?',
                  style: AppTextStyles.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vamos simplificar sua jornada. Metas detalhadas, barras de progresso e estatísticas serão ocultadas para focar apenas no essencial hoje.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    // Botão Cancelar
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.moodInsegura,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancelar',
                          style: AppTextStyles.bodyBold.copyWith(
                            color: AppColors.moodInsegura,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Botão Ativar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.moodInsegura,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text('Ativar', style: AppTextStyles.bodyBold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Círculo Laranja sobreposto
          Positioned(
            top: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.moodInsegura,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backgroundOffWhite,
                  width: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
