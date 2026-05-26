// Arquivo: lib/core/widgets/auth_toggle_switch.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AuthToggleSwitch extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const AuthToggleSwitch({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryActionColor = AppColors.cloudBlue;

    return Container(
      height: 43,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: primaryActionColor, width: 1.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryActionColor,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(true),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTextStyles.bodyBold.copyWith(
                        color: isLogin ? AppColors.white : primaryActionColor,
                        fontSize: 24,
                      ),
                      child: const Text('Log in'),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(false),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTextStyles.bodyBold.copyWith(
                        color: !isLogin ? AppColors.white : primaryActionColor,
                        fontSize: 24,
                      ),
                      child: const Text('Sign in'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}