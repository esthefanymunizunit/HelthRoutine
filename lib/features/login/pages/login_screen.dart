import 'package:flutter/material.dart';
import 'package:healthroutine/features/login/widgets/auth_toggle_switch.dart';
import 'package:healthroutine/features/login/widgets/custom_text_field.dart';
import 'package:healthroutine/features/login/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/widgets/app_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: AppBackground(
                  child: Column(
                    children: [
                      // 2. Área do Logo (Parte Superior)
                      Expanded(
                        child: SafeArea(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/Logo.svg', 
                                  width: 92,
                                  height: 86,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'HealthRoutine',
                                  style: AppTextStyles.heading1.copyWith(
                                    fontSize: 32,
                                    color: AppColors.starYellow,
                                    shadows: [
                                      Shadow(
                                        color: Colors.grey,
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
                              color: AppColors.black,
                              blurRadius: 15,
                              offset: const Offset(0, 15),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            AuthToggleSwitch(
                              isLogin: isLogin, 
                              onChanged: (bool value) => setState(() => isLogin = value)),

                            const SizedBox(height: 40),

                            // --- Campo: Usuário ou Email ---
                            const CustomTextField(hintText: 'Usuário ou Email'),

                            const SizedBox(height: 20),

                            // --- Campo: Senha ---
                            const CustomTextField(hintText: 'Senha', obscureText: true),
                            
                            if(!isLogin) ...[
                              const SizedBox(height: 20),
                              const CustomTextField(hintText: 'Confirmar senha', obscureText: true),
                            ],

                            const SizedBox(height: 30),

                            // --- Botão Principal ---
                            PrimaryButton(
                              text: isLogin ? 'Log in' : 'Sign in', 
                              onPressed: (){

                              },
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
                                SvgPicture.asset(
                                    'assets/icons/facebook.svg', 
                                    width: 29, 
                                    height: 29),
                                
                                const SizedBox(width: 20),
                                
                                SvgPicture.asset(
                                  'assets/icons/google.svg',
                                  width: 32,
                                  height: 32,
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