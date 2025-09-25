import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'base_theme.dart';

/// Sunset Orange theme configuration
class SunsetOrangeTheme {
  SunsetOrangeTheme._();

  static ThemeData get sunsetOrangeTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sunsetOrangePrimary,
        secondary: AppColors.sunsetOrangeAccent,
        tertiary: AppColors.sunsetOrangeAccent,
        surface: AppColors.darkSurface,
        surfaceContainerHighest: Color(0xFF2A2A2A),
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar Theme
      appBarTheme: BaseTheme.getAppBarTheme(
        backgroundColor: Colors.transparent,
        textColor: AppColors.darkTextPrimary,
        iconColor: AppColors.darkTextPrimary,
      ),

      // Navigation Bar Theme
      navigationBarTheme: BaseTheme.getNavigationBarTheme(
        backgroundColor: AppColors.darkSurface,
        primaryColor: AppColors.sunsetOrangePrimary,
        textColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: BaseTheme.getElevatedButtonTheme(
        primaryColor: AppColors.sunsetOrangePrimary,
        isDark: true,
      ),

      // Text Theme
      textTheme: BaseTheme.getTextTheme(
        primaryTextColor: AppColors.darkTextPrimary,
        secondaryTextColor: AppColors.darkTextSecondary,
      ),
    );
  }
}
