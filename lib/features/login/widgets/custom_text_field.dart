// Arquivo: lib/core/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: TextField(
        obscureText: obscureText,
        style: AppTextStyles.bodyBold.copyWith(color: AppColors.black, fontSize: 14),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 14, color: Colors.black38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: AppColors.black.withValues(alpha: 0.15), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.cloudBlue, width: 1.5), // Usei cloudBlue direto ou passe via construtor
          ),
        ),
      ),
    );
  }
}