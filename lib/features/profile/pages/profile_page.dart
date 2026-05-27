import 'package:flutter/material.dart';
import 'package:healthroutine/features/profile/widgets/profile_avatar.dart';
import 'package:healthroutine/features/profile/widgets/profile_card.dart';
import 'package:healthroutine/features/profile/widgets/profile_row.dart';
import 'package:healthroutine/features/profile/widgets/profile_title.dart';
import '../../../core/theme/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  bool _notificationBtn = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.templateBlueLight, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // --- HEADER: AVATAR ---
              const ProfileAvatar(),
              
              const SizedBox(height: 30),

              // --- SEÇÃO: DADOS PESSOAIS ---
              const ProfileSectionCard(
                title: "Dados Pessoais",
                showEditButton: true,
                children: [
                  ProfileInfoRow(label: "Nome", value: "Mariana Silva"),
                  ProfileInfoRow(label: "E-mail", value: "mariana.silva@gmail.com"),
                  ProfileInfoRow(label: "Data de nascimento", value: "12/05/1994"),
                ],
              ),

              const SizedBox(height: 25),

              // --- SEÇÃO: CONFIGURAÇÃO ---
              ProfileSectionCard(
                title: "Configuração da Conta",
                children: [
                  ProfileMenuTile(
                    label: "Notificações", 
                    trailing: Switch(
                      value: _notificationBtn, 
                      onChanged: (bool novoValor) {
                        setState(() {
                          _notificationBtn = novoValor;
                        });
                      },
                      activeTrackColor: AppColors.borderBlue,
                      activeThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.white,
                      inactiveThumbColor: AppColors.borderBlue,
                    ),
                  ),
                  const ProfileMenuTile(label: "Idioma :", subLabel: "Português (BR)"),
                  const ProfileMenuTile(label: "Gerenciar Hábitos"),
                ],
              ),

              const SizedBox(height: 25),

              // --- SEÇÃO: SOBRE ---
              const ProfileSectionCard(
                title: "Sobre o App",
                children: [
                  ProfileMenuTile(label: "Central de Ajuda"),
                  ProfileMenuTile(label: "Política de Privacidade"),
                  ProfileMenuTile(label: "Termos de Uso"),
                  ProfileMenuTile(label: "Versão 2.0-2026", showArrow: false),
                ],
              ),

              const SizedBox(height: 25),

              // --- BOTÃO SAIR ---
              SizedBox(
                width: 238,
                height: 35,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.borderBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Sair", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 120), // Espaço para não cobrir o FAB
            ],
          ),
        ),
      );
  }
}
