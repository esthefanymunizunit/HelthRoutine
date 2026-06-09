import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthroutine/core/services/auth_service.dart';
import 'package:healthroutine/features/login/pages/login_screen.dart';
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

  final AuthService _authService = AuthService();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  bool _notificationBtn = true;

  Future<void> _handleLogout() async {
    try{
      await _authService.signOut();
    } catch (_) {
      await FirebaseAuth.instance.signOut();
    }

    if (mounted){
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => LoginScreen()), 
        (route) => false,
        );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    final String userEmail = _currentUser?.email ?? "email@souunit.com.br";
    
    final String userName = _currentUser?.displayName ?? 
      (userEmail.contains('@') ? userEmail.split('@')[0]: "Usuário");

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
              ProfileSectionCard(
                title: "Dados Pessoais",
                showEditButton: true,
                children: [
                  ProfileInfoRow(label: "Nome", value: userName),
                  ProfileInfoRow(label: "E-mail", value: userEmail),
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
                  onPressed: _handleLogout,
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
