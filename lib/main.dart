import 'package:flutter/material.dart';
import 'package:healthroutine/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Routine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Aqui a mágica acontece: mudamos de MainPage() para SplashScreen()
      home: const SplashScreen(),
    );
  }
}