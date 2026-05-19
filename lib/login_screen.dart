import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variável para alternar entre "Log in" e "Sign in"
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    // Usaremos a blueVariant pois se aproxima mais do azul vivo do Figma para os botões
    const Color primaryActionColor = AppColors.blueVariant; 

    return Scaffold(
      body: Container(
        // 1. Fundo com Gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.cloudBlue,          // Azul claro no topo
              AppColors.backgroundOffWhite, // Tom neutro de transição
              AppColors.white,              // Branco puro na base
            ],
            stops: [0.0, 0.5, 0.7],
          ),
        ),
        child: Column(
          children: [
            // 2. Área do Logo (Parte Superior)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO: Substituir pelo Image.asset() com o logo exportado do Figma
                    const Icon(
                      Icons.auto_awesome, // Ícone que lembra o brilho do logo
                      size: 60,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 10),
                    // Título usando o estilo padrão, com cor sobrescrita para branco
                    Text(
                      'HealthRoutine',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 32,
                        color: AppColors.white,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withOpacity(0.15),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Card Branco Inferior
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40), // Bordas arredondadas no topo
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
                  // --- Seletor Customizado (Log in / Sign in) ---
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundOffWhite, // Fundo cinza bem claro para o toggle
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
                                boxShadow: isLogin ? [
                                  BoxShadow(
                                    color: primaryActionColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ] : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Log in',
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: isLogin ? AppColors.white : Colors.black54,
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
                                boxShadow: !isLogin ? [
                                  BoxShadow(
                                    color: primaryActionColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ] : [],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Sign in',
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: !isLogin ? AppColors.white : Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Campo: Usuário ou Email ---
                  TextField(
                    style: AppTextStyles.bodyBold.copyWith(color: AppColors.black, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Usuário ou Email',
                      hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.black.withOpacity(0.1), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: primaryActionColor, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- Campo: Senha ---
                  TextField(
                    obscureText: true,
                    style: AppTextStyles.bodyBold.copyWith(color: AppColors.black, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: AppColors.black.withOpacity(0.1), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: primaryActionColor, width: 1.5),
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- Botão de Log in ---
                  SizedBox(
                    width: double.infinity, // Ocupa toda a largura do card (com padding)
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementar ação de login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryActionColor,
                        elevation: 4,
                        shadowColor: primaryActionColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isLogin ? 'Log in' : 'Sign in', // Muda o texto dinamicamente
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.white,
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
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Ícones Sociais ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO: Trocar para asset do Facebook
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1877F2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: const Icon(Icons.facebook, color: AppColors.white, size: 28),
                      ),
                      const SizedBox(width: 25),
                      // TODO: Trocar para asset do Google
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
                              color: Colors.red, // Placeholder da cor do Google
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
    );
  }
}