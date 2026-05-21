import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryActionColor = AppColors.cloudBlue; 

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.cloudBlue,          
                        AppColors.backgroundOffWhite, 
                        AppColors.white,              
                      ],
                      stops: [0.0, 0.4, 0.7],
                    ),
                  ),
                  child: Column(
                    children: [
                      // 2. Área do Logo (Parte Superior)
                      Expanded(
                        child: SafeArea(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TODO: Substituir pelo Image.asset() com a estrelinha do Figma
                                const Icon(
                                  Icons.auto_awesome, 
                                  size: 55,
                                  color: AppColors.starYellow, 
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'HealthRoutine',
                                  style: AppTextStyles.heading1.copyWith(
                                    fontSize: 32,
                                    color: AppColors.starYellow,
                                    shadows: [
                                      Shadow(
                                        color: AppColors.black.withOpacity(0.15),
                                        offset: const Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // 3. Card Branco Inferior
                      Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50), 
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, -5),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(color: primaryActionColor, width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isLogin = true),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isLogin ? primaryActionColor : Colors.transparent,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Log in',
                                          style: AppTextStyles.bodyBold.copyWith(
                                            color: isLogin ? AppColors.white : primaryActionColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => isLogin = false),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: !isLogin ? primaryActionColor : Colors.transparent,
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Sign in',
                                          style: AppTextStyles.bodyBold.copyWith(
                                            color: !isLogin ? AppColors.white : primaryActionColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // --- Campo: Usuário ou Email ---
                            TextField(
                              style: AppTextStyles.bodyBold.copyWith(color: AppColors.black, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Usuário ou Email',
                                hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 14, color: Colors.black38),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: AppColors.black.withOpacity(0.15), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: primaryActionColor, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // --- Campo: Senha ---
                            TextField(
                              obscureText: true,
                              style: AppTextStyles.bodyBold.copyWith(color: AppColors.black, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Senha',
                                hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 14, color: Colors.black38),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: AppColors.black.withOpacity(0.15), width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: primaryActionColor, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // --- Botão Principal ---
                            SizedBox(
                              width: 200, 
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Ação
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryActionColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  isLogin ? 'Log in' : 'Sign in', 
                                  style: AppTextStyles.heading2.copyWith(
                                    color: AppColors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // --- Divisor "ou" ---
                            Text(
                              'ou',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // --- Ícones Sociais ---
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1877F2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.facebook, color: AppColors.white, size: 28),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'G',
                                      style: AppTextStyles.heading1.copyWith(
                                        color: Colors.red, 
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}