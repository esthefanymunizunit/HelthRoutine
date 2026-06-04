import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthroutine/core/constants/app_strings.dart';
import 'package:healthroutine/core/services/auth_service.dart';
import 'package:healthroutine/features/login/widgets/auth_toggle_switch.dart';
import 'package:healthroutine/features/login/widgets/custom_text_field.dart';
import 'package:healthroutine/features/login/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLogin = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _humanReadableErrorFor(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AppStrings.authErrorInvalidEmail;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AppStrings.authErrorInvalidCredentials;
      case 'email-already-in-use':
        return AppStrings.authErrorUserExists;
      case 'weak-password':
        return AppStrings.authErrorWeakPassword;
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
        return AppStrings.authErrorGoogleSignInAborted;
      default:
        return AppStrings.authErrorGeneric;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.alertRed,
      ),
    );
  }

  Future<void> _handleEmailPasswordSubmit() async {
    if (_isAuthenticating) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar(AppStrings.authErrorEmptyFields);
      return;
    }
    if (!isLogin && password != confirmPassword) {
      _showErrorSnackBar(AppStrings.authErrorPasswordMismatch);
      return;
    }

    setState(() => _isAuthenticating = true);
    try {
      if (isLogin) {
        await _authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await _authService.signUpWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (exception) {
      if (mounted) _showErrorSnackBar(_humanReadableErrorFor(exception));
    } on AuthDomainException catch (exception) {
      if (mounted) _showErrorSnackBar(exception.message);
    } catch (_) {
      if (mounted) _showErrorSnackBar(AppStrings.authErrorGeneric);
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isAuthenticating) return;

    setState(() => _isAuthenticating = true);
    try {
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (exception) {
      if (mounted) _showErrorSnackBar(_humanReadableErrorFor(exception));
    } on AuthDomainException catch (exception) {
      if (mounted) _showErrorSnackBar(exception.message);
    } catch (_) {
      if (mounted) _showErrorSnackBar(AppStrings.authErrorGeneric);
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

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
                      SafeArea(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
                            Row(
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
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 25,
                          ),
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
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AuthToggleSwitch(
                                isLogin: isLogin,
                                onChanged: (bool value) =>
                                    setState(() => isLogin = value),
                              ),
                              const SizedBox(height: 40),
                              CustomTextField(
                                hintText: 'Usuário ou Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              CustomTextField(
                                hintText: 'Senha',
                                obscureText: true,
                                controller: _passwordController,
                              ),
                              if (!isLogin) ...[
                                const SizedBox(height: 20),
                                CustomTextField(
                                  hintText: 'Confirmar senha',
                                  obscureText: true,
                                  controller: _confirmPasswordController,
                                ),
                              ],
                              const SizedBox(height: 30),
                              PrimaryButton(
                                text: isLogin ? 'Log in' : 'Sign in',
                                onPressed: _handleEmailPasswordSubmit,
                              ),
                              const SizedBox(height: 25),
                              Text(
                                'ou',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/facebook.svg',
                                    width: 29,
                                    height: 29,
                                  ),
                                  const SizedBox(width: 20),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: _handleGoogleSignIn,
                                    child: SvgPicture.asset(
                                      'assets/icons/google.svg',
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (_isAuthenticating) ...[
                                const SizedBox(height: 8),
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.cloudBlue,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ],
                            ],
                          ),
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
