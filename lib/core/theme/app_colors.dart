import 'package:flutter/material.dart';

class AppColors {
  // --- Cores Base e Neutras ---
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color backgroundOffWhite = Color(
    0xFFF7F2EF,
  ); // Fundo do modal "Nova Tarefa"

  // --- Moods (Check-in Diário) ---
  static const Color moodAnimada = Color(0xFFF9ABD3);
  static const Color moodSensivel = Color(0xFF02ADFD);
  static const Color moodBrava = Color(0xFFF96000);
  static const Color moodInsegura = Color(0xFFFBA301);

  // --- Cards de Atividades (Aba Hoje) ---
  static const Color activityPink = Color(
    0xFFF5BCDD,
  ); // Caminhar com o cachorro
  static const Color activityBlue = Color(0xFFBACDED); // Estudar / Beber água
  static const Color activityGreen = Color(0xFF9EB071); // Meditação Rápida

  // --- Templates (Domingo Reset) ---
  static const Color templatePink = Color(0xFFF9ABD3); // Foco nos estudos
  static const Color templateGreenDark = Color(
    0xFF3D7F40,
  ); // Semana Sob Controle
  static const Color templateBlueLight = Color(0xFF6DBADE); // Ambiente Renovado
  static const Color templatePurpleLight = Color(
    0xFFB593D4,
  ); // Corpo Ativo e Nutrido
  static const Color templatePurpleDark = Color(0xFFA770CD);

  // --- Ícones, Destaques e Gráficos ---
  static const Color starYellow = Color(0xFFFBBB01); // Estrelinha / Mascote
  static const Color nutritionBrown = Color(0xFF976226); // Ícone do ovo
  static const Color alertRed = Color(0xFF930101); // Alerta no Mood Calendar
  static const Color cloudBlue = Color(0xFF53B4E0); // Ícone da nuvem / timer
  static const Color softYellow = Color(0xFFF3D98E);

  // --- Variações Extras ---
  static const Color blueVariant = Color(0xFF04ABF7); // Similar ao moodSensivel
}
