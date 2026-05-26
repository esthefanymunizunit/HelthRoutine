import 'package:flutter/material.dart';
import 'package:healthroutine/core/theme/app_theme.dart';
import 'package:healthroutine/features/login/pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthRoutine',
      debugShowCheckedModeBanner: false,
      
      theme: AppTheme.lightTheme, 
      
      home: const LoginScreen(), 
    );
  }
}