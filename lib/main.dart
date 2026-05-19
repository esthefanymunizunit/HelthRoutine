import 'package:flutter/material.dart';
import 'package:healthroutine/core/theme/app_theme.dart';
import 'package:healthroutine/features/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthRoutine',
      debugShowCheckedModeBanner: false, // Remove aquela faixa vermelha de "DEBUG" da tela
      
      // 1. Integrando o Tema da sua equipe
      theme: AppTheme.lightTheme, 
      
      // 2. Definindo a Tela de Login como a tela inicial do app
      home: const LoginScreen(), 
    );
  }
}