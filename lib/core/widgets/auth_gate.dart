import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../features/login/pages/login_screen.dart';
import '../main_page.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class AuthGate extends StatelessWidget {
  final AuthService authService;

  AuthGate({super.key, AuthService? authService})
      : authService = authService ?? AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.blueVariant),
            ),
          );
        }
        final user = snapshot.data;
        if (user == null) return const LoginScreen();
        return const MainPage();
      },
    );
  }
}
