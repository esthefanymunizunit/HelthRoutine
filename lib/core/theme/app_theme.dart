import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.activityBlue,
      // Define a tipografia padrão para os widgets do Material
      textTheme: TextTheme(
        displayLarge: AppTextStyles.heading1,
        titleLarge: AppTextStyles.heading2,
        bodyLarge: AppTextStyles.bodyBold,
        bodySmall: AppTextStyles.bodySmall,
      ),
      useMaterial3: true,
    );
  }
}
