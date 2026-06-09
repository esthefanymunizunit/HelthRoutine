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
  String _localName = "";

  @override
  void initState() {
    super.initState();
    final String userEmail = _currentUser?.email ?? "";
    _localName = _currentUser?.displayName ?? 
        (userEmail.contains('@') ? userEmail.split('@')[0] : "Usuário");
  }

  void _showEditNameDialog() {
    final TextEditingController nameController = TextEditingController(text: _localName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Nome de Usuário"),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: AppColors.black),
            decoration: const InputDecoration(
              hintText: "Digite seu nome",
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.cloudBlue),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cloudBlue),
              onPressed: () async {
                final novoNome = nameController.text.trim();
                if (novoNome.isNotEmpty && _currentUser != null) {
                  try {
                    // 1. Atualiza o nome direto no core do Firebase Auth
                    await _currentUser.updateDisplayName(novoNome);
                    // 2. Força o recarregamento do usuário para persistir os dados locais
                    await _currentUser.reload(); 
                    
                    setState(() {
                      _localName = novoNome; // 3. Atualiza a UI do Flutter
                    });
                    
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erro ao atualizar o nome.")),
                      );
                    }
                  }
                }
              },
              child: const Text("Salvar", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _confirmarEncerramentoSessao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Sair da Conta", 
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Tem certeza que deseja sair do HealthRoutine?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Não", 
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _handleLogout();
              },
              child: const Text(
                "Sim", 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

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
                onEditPressed: _showEditNameDialog,
                children: [
                  ProfileInfoRow(label: "Nome", value: _localName),
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
                  onPressed: _confirmarEncerramentoSessao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.borderBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Sair da Conta", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 120), // Espaço para não cobrir o FAB
            ],
          ),
        ),
      );
  }
}
