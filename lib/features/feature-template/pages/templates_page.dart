import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

import 'template_details_page.dart';
import '../widgets/template_card.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.templatesHeader,
                      style: AppTextStyles.heading1,
                    ),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        'assets/images/icon-perfil.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.templatesDesc,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        'assets/images/estrela-virada.png',
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  AppStrings.templatesSectionTitle,
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  clipBehavior: Clip.none,
                  children: [
                    TemplateCard(
                      title: AppStrings.tplFocoTitle,
                      desc: AppStrings.tplFocoDesc,
                      color: const Color(0xFFFCAFE9),
                      titleColor: const Color(0xFF6A3B54),
                      icon: Icons.star,
                      iconColor: AppColors.starYellow,
                      iconBgColor: Colors.white.withOpacity(0.6),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TemplateDetailsPage(
                              title: AppStrings.tplFocoTitle,
                              color: Color(0xFFFCAFE9),
                              tasks: [
                                {
                                  'title': 'Estudar 1h - Método Promodoro',
                                  'start': '9:00 AM',
                                  'end': '10:00 AM',
                                },
                                {
                                  'title': 'Salvar e organizar arquivos',
                                  'start': '11:00 AM',
                                  'end': '11:30 AM',
                                },
                                {
                                  'title': 'Revisar Conteúdo',
                                  'start': '2:00 PM',
                                  'end': '3:00 PM',
                                },
                                {
                                  'title': 'Leitura técnica',
                                  'start': '5:00 PM',
                                  'end': '6:00 PM',
                                },
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    TemplateCard(
                      title: AppStrings.tplSemanaTitle,
                      desc: AppStrings.tplSemanaDesc,
                      color: const Color(0xFF4C8D4F),
                      titleColor: const Color(0xFF1B401C),
                      icon: Icons.star,
                      iconColor: Colors.white,
                      iconBgColor: Colors.white.withOpacity(0.3),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TemplateDetailsPage(
                              title: AppStrings.tplSemanaTitle,
                              color: Color(0xFF4C8D4F),
                              tasks: [
                                {
                                  'title': 'Planejar tarefas da semana',
                                  'start': '8:00 AM',
                                  'end': '8:30 AM',
                                },
                                {
                                  'title': 'Limpar caixa de entrada',
                                  'start': '8:30 AM',
                                  'end': '9:00 AM',
                                },
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    TemplateCard(
                      title: AppStrings.tplAmbienteTitle,
                      desc: AppStrings.tplAmbienteDesc,
                      color: const Color(0xFF71C1E8),
                      titleColor: const Color(0xFF2C556A),
                      icon: Icons.star,
                      iconColor: Colors.white,
                      iconBgColor: Colors.white.withOpacity(0.4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TemplateDetailsPage(
                              title: AppStrings.tplAmbienteTitle,
                              color: Color(0xFF71C1E8),
                              tasks: [
                                {
                                  'title': 'Arrumar a mesa de trabalho',
                                  'start': '7:00 AM',
                                  'end': '7:15 AM',
                                },
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    TemplateCard(
                      title: AppStrings.tplCorpoTitle,
                      desc: AppStrings.tplCorpoDesc,
                      color: const Color(0xFFBE9DDC),
                      titleColor: const Color(0xFF4A345E),
                      icon: Icons.star,
                      iconColor: Colors.white,
                      iconBgColor: Colors.white.withOpacity(0.4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TemplateDetailsPage(
                              title: AppStrings.tplCorpoTitle,
                              color: Color(0xFFBE9DDC),
                              tasks: [
                                {
                                  'title': 'Alongamento matinal',
                                  'start': '6:00 AM',
                                  'end': '6:20 AM',
                                },
                                {
                                  'title': 'Beber 500ml de água',
                                  'start': '6:20 AM',
                                  'end': '6:25 AM',
                                },
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
