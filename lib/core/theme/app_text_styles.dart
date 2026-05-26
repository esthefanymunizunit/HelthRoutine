import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Título grandão (Ex: "Olá, Mariana !", "Domingo Reset")
  static TextStyle heading1 = GoogleFonts.konkhmerSleokchher(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  // Títulos de seções (Ex: "Atividades de Hoje", "Sugerido para você")
  static TextStyle heading2 = GoogleFonts.konkhmerSleokchher(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  // Texto padrão de botões e cards (Ex: "Caminhar com o cachorro")
  static TextStyle bodyBold = GoogleFonts.konkhmerSleokchher(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Texto descritivo menor (Ex: "Como você está hoje?", "Alimentos que ajudam...")
  static TextStyle bodySmall = GoogleFonts.konkhmerSleokchher(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}
